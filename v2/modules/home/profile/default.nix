{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  email = "colton@donn.io";
  name = "Colton Donnelly";

  cfg = config.mistman.profile;
in

{
  options.mistman.profile = {
    enable = mkEnableOption "my base dotfiles";
  };

  config = mkIf cfg.enable {
    mistman = {
      extras.enable = true;
      nix.enable = true;
      nvim.enable = true;
      shells.enable = true;
      starship.enable = true;
    };

    enableNixpkgsReleaseCheck = true;
    stateVersion = "24.2";
    username = "colton";

    programs = {
      direnv.config.whitelist.prefix = [
        "/Users/colton/github.com/cdmistman"
        "/home/colton/github.com/cdmistman"
      ];

      git = {
        userEmail = email;
        userName = name;
      };
    };
  };
}

