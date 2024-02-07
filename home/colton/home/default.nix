{
  enableGUI,
  pkgs,
  ...
}: {
  xdg.enable = true;
  home = {
    file = import ./files.nix;

    enableNixpkgsReleaseCheck = true;
    stateVersion = "22.11";
    username = "colton";

    packages = with pkgs;
      [
        cachix
        comma
        direnv
        docker
        du-dust
        fd
        jless
        jq
        nil
        nixd
        nixpkgs-review
        obsidian
        procs
        ripgrep
        sd
        tokei
      ];

    sessionPath = [
      "$HOME/bin"
    ];

    sessionVariables = {
      MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
      MANROFFOPT = "-c";

      PAGER = "${pkgs.bat}/bin/bat";
    };

    shellAliases = {
      k = "clear";
      kn = "clear && printf '\\e[3J'";

      ls = "${pkgs.lsd}/bin/lsd -AL --group-directories-first";
      l = "ls";
      la = "ls -a";
      ll = "ls -l";
      lla = "ls -al";
      tree = "${pkgs.lsd}/bin/lsd -L --tree";
    };
  };
}
