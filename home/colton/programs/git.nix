{
  programs.git = {
    enable = true;

    userEmail = "colton@donn.io";
    userName = "Colton Donnelly";

    aliases = {
      c = "commit";
      ca = "!git add -A && git commit";
      cam = "!git add -A && git commit -m";
      cm = "commit -m";

      ignore = "update-index --assume-unchanged";
      unignore = "update-index --no-assume-unchanged";
    };

    extraConfig = {
      init.defaultBranch = "main";

      pull.rebase = false;
      push.autoSetupRemote = true;

      url."ssh://git@github.com".insteadOf = "github";
    };
  };
}
