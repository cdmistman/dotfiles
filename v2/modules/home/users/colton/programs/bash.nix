{ config, lib, ... }:
lib.mkIf config.mistman.users.colton.enable {
  programs.bash = {
    enable = true;
    enableCompletion = true;

    historyIgnore = [
      "exit"
    ];
  };
}
