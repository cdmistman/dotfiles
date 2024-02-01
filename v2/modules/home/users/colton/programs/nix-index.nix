{ config, lib, ... }:
lib.mkIf config.mistman.users.colton.enable {
  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    # TODO: enableNushellIntegration = true;
    enableZshIntegration = true;
  };
}
