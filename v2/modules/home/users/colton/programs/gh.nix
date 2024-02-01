{config, lib, pkgs, ...}: lib.mkIf config.mistman.users.colton.enable {
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;

    settings = {
      editor = "${pkgs.helix}/bin/hx";

      git_protocol = "ssh";

      prompt = "enabled";
    };
  };
}
