# vanillin gives vanilla its flavor
{config, lib, pkgs, ...}:

let
  cfg = config.vanillinvim;

  inherit (lib) concatLines mapAttrs mapAttrsToList mkEnableOption mkIf mkOption types;

  build-plugin = name: plugin: pkgs.runCommand "vanillinvim-plugin-${name}" {
    nativeBuildInputs = [ cfg.package ];
  } ''
    set -exo pipefail

    mkdir -p $out
    cp -R ${plugin}/* $out

    if [[ -d $out/doc ]]; then
      chmod +w $out/doc
      nvim --headless --clean -n +":helptags ++t $out/doc" +q
      stat $out/doc/tags >/dev/null || exit 1
    fi

    set +ex
  '';

  static-config-dir = pkgs.runCommand "vanillinvim-config" { } ''
    set -euxo pipefail

    configDir=$out/nvim
    mkdir -p $configDir

    packDir=$configDir/pack/vanillinvimPlugins/start
    mkdir -p $packDir

    stat $packDir >/dev/null || exit 127
    ${concatLines
      (mapAttrsToList
        (name: plugin: "ln -s ${plugin} $packDir/${name}")
        (mapAttrs build-plugin cfg.plugins))}

    set +ex
  '';

  fallback-tools-dir = pkgs.symlinkJoin {
    name = "vanillinvim-fallback-tools";
    paths = cfg.fallback-tools;
  };

  tools-dir = pkgs.symlinkJoin {
    name = "vanillinvim-tools";
    paths = cfg.tools;
  };

  finalPackage = pkgs.runCommand "vanillinvim" {
    nativeBuildInputs = [
      pkgs.makeWrapper
    ];
  } ''
    mkdir -p $out/bin

    makeWrapper ${cfg.package}/bin/nvim $out/bin/nvim \
      --prefix XDG_CONFIG_DIRS : ${static-config-dir} \
      --prefix PATH : ${tools-dir}/bin \
      --suffix PATH : ${fallback-tools-dir}/bin
  '';
in

{
  options.vanillinvim = {
    enable = mkEnableOption "vanillinvim";

    package = mkOption {
      type = types.package;
      default = pkgs.neovim-unwrapped;
      defaultText = "pkgs.neovim-unwrapped";
      description = "neovim package to use";
    };

    tools = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Package containing tools to prepend to the PATH.";
    };

    fallback-tools = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Package containing an extra fallback PATH entry.";
    };

    parsers = mkOption {
      type = types.listOf types.package;
      description = "The tree-sitter parsers to make available.";
      default = [];
    };

    plugins = mkOption {
      type = types.attrsOf types.path;
      default = {};
      description = "Plugins to install into the packpath.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ finalPackage ];
  };
}
