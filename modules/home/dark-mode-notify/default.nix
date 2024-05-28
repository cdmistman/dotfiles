{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.dark-mode-notify;

  inherit (builtins) abort map toJSON;
  inherit (lib) concatLines mkEnableOption mkIf mkOption mkPackageOption types;
  inherit (inputs.home-manager.lib) hm;
in {
  options.services.dark-mode-notify = {
    enable = mkEnableOption "dark-mode-notify, a tool that automatically runs scripts when macOS changes themes.";

    package = mkPackageOption pkgs "dark-mode-notify" {};

    logPath = mkOption {
      type = types.path;
      default = "/tmp/dark-mode-notify.log";
      description = "The base path to the log files.";
    };

    scripts = mkOption {
      type = hm.types.dagOf types.str;
      default = {};
      description = "Scripts to run when macOS changes themes.";
      example = lib.literalExpression ''        {
                 myThemeAction = lib.hm.dag.entryAfter ["kitty"] '''
                   run ln -s $VERBOSE_ARG \
                       ''${builtins.toPath ./link-me-directly} $HOME
                 ''';
              }'';
    };

    script = mkOption {
      type = types.package;
      description = "The generated script for dark-mode-notify to run. Please use `services.dark-mode-notify.scripts` to configure.";
      readOnly = true;
    };
  };

  config = mkIf (pkgs.stdenv.isDarwin && cfg.enable) {
    home.packages = [cfg.package];

    services.dark-mode-notify.script = lib.pipe cfg.scripts [
      hm.dag.topoSort
      (s:
        if s ? result
        then s.result
        else abort ("Dependency cycle in activation script: " + toJSON cfg.scripts))
      (map ({
        name,
        data,
      }: ''
        echo 'running hook for "${name}"'
        ${data}
      ''))
      concatLines
      (pkgs.writeShellScript "on-dark-mode-notified")
    ];

    launchd.agents.dark-mode-notify = {
      enable = true;
      config = {
        KeepAlive = true;
        Label = "ke.bou.dark-mode-notify";
        ProgramArguments = ["${cfg.package}/bin/dark-mode-notify" "${cfg.script.outPath}"];
        StandardOutPath = cfg.logPath + ".stdout";
        StandardErrorPath = cfg.logPath + ".stderr";
      };
    };
  };
}
