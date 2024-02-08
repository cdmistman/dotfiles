{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mistman.nix;
in

{
  options.mistman.nix = {
    enable = mkEnableOption "my Nix settings";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.nixVersions.nix_2_18
    ];

    nix = {
      package = pkgs.nixVersions.nix_2_18;

      registry = {
        me = {
          from = {
            type = "indirect";
            id = "me";
          };

          to = {
            type = "github";
            owner = "cdmistman";
            repo = "dotfiles";
          };
        };
      };
    };
  };
}

