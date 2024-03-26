# much of this file is derived from
# https://github.com/NixOS/nixpkgs/blob/44d0940ea560dee511026a53f0e2e2cde489b4d4/nixos/modules/services/web-apps/gerrit.nix
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.gerrit;
  inherit (lib) mkEnableOption mkForce mkIf mkOption mkPackageOption types;
  inherit (pkgs) runCommand writeShellScriptBin writeText;

  gitIniType = with types;
    let
      primitiveType = either str (either bool int);
      multipleType = either primitiveType (listOf primitiveType);
      sectionType = lazyAttrsOf multipleType;
      supersectionType = lazyAttrsOf (either multipleType sectionType);
    in lazyAttrsOf supersectionType;

  gerritConfig = writeText "gerrit.conf" (
    lib.generators.toGitINI cfg.settings
  );

  replicationConfig = writeText "replication.conf" (
    lib.generators.toGitINI cfg.replicationSettings
  );

  # Wrap the gerrit java with all the java options so it can be called
  # like a normal CLI app
  gerrit-cli = writeShellScriptBin "gerrit" ''
    set -euo pipefail
    jvmOpts=(
      ${lib.escapeShellArgs cfg.jvmOpts}
      -Xmx${cfg.jvmHeapLimit}
    )
    exec ${cfg.jvmPackage}/bin/java \
      "''${jvmOpts[@]}" \
      -jar ${cfg.package}/webapps/${cfg.package.name}.war \
      "$@"
  '';

  gerrit-plugins = runCommand
    "gerrit-plugins"
    {
      buildInputs = [ gerrit-cli ];
    }
    ''
      shopt -s nullglob
      mkdir $out

      for name in ${toString cfg.builtinPlugins}; do
        echo "Installing builtin plugin $name.jar"
        gerrit cat plugins/$name.jar > $out/$name.jar
      done

      for file in ${toString cfg.plugins}; do
        name=$(echo "$file" | cut -d - -f 2-)
        echo "Installing plugin $name"
        ln -sf "$file" $out/$name
      done
    '';
in

{
  options.services.gerrit = {
    enable = mkEnableOption "gerrit";

    package = mkPackageOption pkgs "gerrit" { };

    finalPackage = mkOption {
      type = types.package;
      readOnly = true;
      description = "The actual package to run.";
    };

    jvmPackage = mkPackageOption pkgs "jre_headless" { };

    jvmOpts = mkOption {
      type = types.listOf types.str;
      default = [
        "-Dflogger.backend_factory=com.google.common.flogger.backend.log4j.Log4jBackendFactory#getInstance"
        "-Dflogger.logging_context=com.google.gerrit.server.logging.LoggingContext#getInstance"
      ];
      description = lib.mdDoc "A list of JVM options to start gerrit with.";
    };

    jvmHeapLimit = mkOption {
      type = types.str;
      default = "1024m";
      description = lib.mdDoc ''
        How much memory to allocate to the JVM heap
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "[::]:8080";
      description = lib.mdDoc ''
        `hostname:port` to listen for HTTP traffic.

        This is bound using the systemd socket activation.
      '';
    };

    settings = mkOption {
      type = gitIniType;
      default = {};
      description = lib.mdDoc ''
        Gerrit configuration. This will be generated to the
        `etc/gerrit.config` file.
      '';
    };

    replicationSettings = mkOption {
      type = gitIniType;
      default = {};
      description = lib.mdDoc ''
        Replication configuration. This will be generated to the
        `etc/replication.config` file.
      '';
    };

    plugins = mkOption {
      type = types.listOf types.package;
      default = [];
      description = lib.mdDoc ''
        List of plugins to add to Gerrit. Each derivation is a jar file
        itself where the name of the derivation is the name of plugin.
      '';
    };

    builtinPlugins = mkOption {
      type = types.listOf (types.enum cfg.package.passthru.plugins);
      default = [];
      description = lib.mdDoc ''
        List of builtins plugins to install. Those are shipped in the
        `gerrit.war` file.
      '';
    };

    serverId = mkOption {
      type = types.str;
      description = lib.mdDoc ''
        Set a UUID that uniquely identifies the server.

        This can be generated with
        `nix-shell -p util-linux --run uuidgen`.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.gerrit = mkForce {
      # derived from
      # https://github.com/NixOS/nixpkgs/blob/44d0940ea560dee511026a53f0e2e2cde489b4d4/nixos/modules/services/web-apps/gerrit.nix#L193-L213
      finalPackage = writeShellScriptBin "gerrit" ''
        set -euo pipefail
        # bootstrap if nothing exists
        if [[ ! -d git ]]; then
          gerrit init --batch --no-auto-start
        fi

        # install gerrit.war for the plugin manager
        rm -rf bin
        mkdir bin
        ln -sfv ${cfg.package}/webapps/${cfg.package.name}.war bin/gerrit.war

        # copy the config, keep it mutable because Gerrit
        ln -sfv ${gerritConfig} etc/gerrit.config
        ln -sfv ${replicationConfig} etc/replication.config

        # install the plugins
        rm -rf plugins
        ln -sv ${gerrit-plugins} plugins
      '';

      settings = {
        cache.directory = "/var/cache/gerrit";
        container.heapLimit = cfg.jvmHeapLimit;
        gerrit.basePath = lib.mkDefault "git";
        gerrit.serverId = cfg.serverId;
        httpd.inheritChannel = "true";
        httpd.listenUrl = lib.mkDefault "http://${cfg.listenAddress}";
        index.type = lib.mkDefault "lucene";
      };
    };

    environment.systemPackages = [ gerrit-cli ];

    launchd.daemons.gerrit = {
      serviceConfig = {
        Label = "com.google.gerrit.gerrit";
        ProgramArguments = [
          "/bin/sh" "-c"
          "/bin/wait4path ${cfg.finalPackage} &amp;&amp; ${cfg.finalPackage}/bin/gerrit daemon --console-log"
        ];
        RunAtLoad = true;
        UserName = "gerrit";
        GroupName = "gerrit";
      };

      path = [
        gerrit-cli
        pkgs.bash
        pkgs.coreutils
        pkgs.git
        pkgs.openssh
      ];

      environment = {
        GERRIT_HOME = "%S/gerrit";
        GERRIT_TMP = "%T";
        HOME = "%S/gerrit";
        XDG_CONFIG_HOME = "%S/gerrit/.config";
      };
    };

    users.knownGroups = config.users.knownGroups ++ [ "gerrit" ];
    users.groups.gerrit = { };
    users.knownUsers = config.users.knownUsers ++ [ "gerrit" ];
    users.users.gerrit = { };
  };
}
