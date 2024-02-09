{ config, inputs, lib, system, ... }:

let
  inherit (lib) mkEnableOption mkForce mkIf mkOption types;

  cfg = config.mistman.nvim;
in

{
  options.mistman.nvim = {
    enable = mkEnableOption "My nvim configuration at https://github.com/cdmistman/nvim";

    defaultEditor = mkEnableOption "EDITOR env var set to nvim";

    config = mkOption {
      default = inputs.nvim.packages.${system};
    };

    package = mkOption {
      type = types.package;
      description = "The final package";
      readOnly = true;
    };
  };

  config = mkIf cfg.enable {
    mistman.nvim.package = cfg.config.neovim-with-plugins;

    programs.neovim.enable = mkForce false;

    home = {
      packages = [
        cfg.package
      ];

      sessionVariables.EDITOR = "${cfg.package}/bin/nvim";
    };

    programs.gh.settings.editor = "${cfg.package}/bin/nvim";

    xdg.configFile."nvim" = {
      enable = true;
      source = cfg.config.config-dir;
    };
  };
}

