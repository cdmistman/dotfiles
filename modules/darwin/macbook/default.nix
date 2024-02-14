{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mistman.macbook;
in

{
  options.mistman.macbook = {
    enable = mkEnableOption "configurations for my macbooks";
  };

  config = mkIf cfg.enable {
    security.pam.enableSudoTouchIdAuth = true;

    system.keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };

    users.users.admin = {
      createHome = true;
      description = "Admin user";
      home = "/Users/admin";
      isHidden = false;
    };

    users.users.colton = {
      createHome = false;
      description = "coolton";
      home = "/Users/colton";
      isHidden = false;
    };
  };
}
