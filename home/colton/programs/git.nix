{
  programs.git = {
    enable = true;

    userEmail = "colton@donn.io";
    userName = "Colton Donnelly";

    aliases = {
      ca = "commit -a";
      cam = "commit -am";
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
