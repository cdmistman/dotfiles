{config, lib, pkgs, ...}: lib.mkIf config.mistman.users.colton.enable {
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batgrep
      batman
    ];
  };
}
