{ config, lib, ... }: lib.mkIf config.mistman.users.colton.enable {
  programs.bottom = {
    enable = true;
  };
}
