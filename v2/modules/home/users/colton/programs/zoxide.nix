{ config, lib, ... }: lib.mkIf config.mistman.users.colton.enable {
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };
}
