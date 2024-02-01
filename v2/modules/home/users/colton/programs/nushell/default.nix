{ config, lib, ... }:
lib.mkIf config.mistman.users.colton.enable {
  programs.nushell = {
    enable = true;

    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
    # loginFile.source = ./login.nu;
  };
}
