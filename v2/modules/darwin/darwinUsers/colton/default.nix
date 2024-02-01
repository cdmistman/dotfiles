{ config, lib, ... }:

let
  cfg = config.mistman.darwinUsers.colton;
in

{
  options.mistman.darwinUsers.colton.enable = lib.mkEnableOption "darwinUsers.colton";

  config = lib.mkIf cfg.enable {
    nix.settings.trusted-users = [ "colton" ];

    users.users.colton = {
      createHome = false;
      description = "Coolton";
      home = "/Users/colton";
      isHidden = false;
    };
  };
}

