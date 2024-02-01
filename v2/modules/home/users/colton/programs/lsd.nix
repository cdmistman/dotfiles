{ config, lib, ... }: lib.mkIf config.mistman.users.colton.enable {
  programs.lsd = {
    enable = true;
  };
}
