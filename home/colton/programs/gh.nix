{pkgs, ...}: {
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
