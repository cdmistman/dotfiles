{ config, lib, ... }:
lib.mkIf config.mistman.users.colton.enable {
  home.file.".config/zellij/config.kdl".source = ./config.kdl;

  programs.zellij = {
    enable = true;
  };
}
