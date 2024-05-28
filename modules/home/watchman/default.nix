{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.watchman;

  inherit (builtins) toJSON;
  inherit (lib) mkEnableOption mkIf mkOption mkPackageOption optional types;
in {
  options.services.watchman = {
    enable = mkEnableOption "watchman";

    package = mkPackageOption pkgs "watchman" {};

    pywatchman = {
      enable = mkEnableOption "pywatchman";
      package = mkPackageOption pkgs.python312Packages "pywatchman" {};
    };

    settings = mkOption {
      description = "the global watchman configuration options";
      type = types.attrs;
      default = {};
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package] ++ optional cfg.pywatchman.enable cfg.pywatchman.package;

    home.sessionVariables.WATCHMAN_CONFIG_FILE = "${config.xdg.configHome}/watchman.json";

    xdg.configFile."watchman.json".text = toJSON cfg.settings;
  };
}
