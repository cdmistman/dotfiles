{ config, lib, ... }: lib.mkIf config.mistman.users.colton.enable {
  programs.helix = {
    enable = true;
  };
}
