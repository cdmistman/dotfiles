{ config, lib, ... }: lib.mkIf config.mistman.users.colton.enable {
  programs.tealdeer = {
    enable = true;
  };
}
