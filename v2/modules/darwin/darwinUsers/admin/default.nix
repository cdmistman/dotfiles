{ lib, config, ... }:

let
  cfg = config.mistman.darwinUsers.admin;
in

{
  options.mistman.darwinUsers.admin.enable = lib.mkEnableOption "darwinUsers.admin";

  config = lib.mkIf cfg.enable {
    nix.settings.trusted-users = [ "admin" ];

    users.users.admin = {
      createHome = true;
      description = "Admin user";
      home = "/Users/admin";
      isHidden = false;
    };
  };
}

