{pkgs, ...}: {
  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;

    settings = {
      editor = "${pkgs.helix}/bin/hx";

      git_protocol = "ssh";

      prompt = "enabled";
    };
  };
}
