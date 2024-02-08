{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mistman.nushell;
in

{
  options.mistman.nushell = {
    enable = mkEnableOption "Enable GUI apps";
  };

  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true;

      historyIgnore = [
        "exit"
      ];
    };

    programs.nushell = {
      enable = true;

      configFile.source = ./nu/config.nu;
      envFile.source = ./nu/env.nu;
      loginFile.source = ./nu/login.nu;
    };

    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;

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
    };
  };
}
