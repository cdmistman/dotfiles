{ config, lib, pkgs, ... }: lib.mkIf (config.mistman.profile.enable) {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    autocd = false;

    defaultKeymap = "viins";

    history = {
      expireDuplicatesFirst = true;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "vi-mode"
      ];
    };

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }
    ];

    shellGlobalAliases = {
      "-- --help" = "--help 2>&1 | bat --language=help --style=plain";
    };
  };
}
