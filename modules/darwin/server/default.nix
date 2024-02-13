{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mistman.server;
in

{
  options.mistman.server = {
    enable = mkEnableOption "configurations for my darwin servers";
  };

  config = lib.mkIf cfg.enable {
    users.users.admin = {
      createHome = false;
      description = "Admin user";
      home = "/Users/admin";
      isHidden = false;
    };

    users.users.colton = {
      createHome = true;
      description = "Colton";
      home = "/Users/colton";
      isHidden = true;
    };
  };
}
