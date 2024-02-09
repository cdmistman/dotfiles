{ config, inputs, lib, pkgs, system, ...}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mistman.extras;
in

{
  options.mistman.extras = {
    enable = mkEnableOption "Some extra configurations";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        cachix
        comma
        du-dust
        fd
        jless
        jq
        nil
        nixd
        procs
        ripgrep
        sd
        tokei
      ];

      sessionPath = [
        "$HOME/bin"
      ];

      sessionVariables = {
        MANPAGER = "sh -c 'col -bx | ${pkgs.bat} -l man -p'";
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

    editorconfig = {
      enable = true;

      settings = {
        "*" = {
          charset = "utf-8";
          end_of_line = "lf";
          indent_size = 2;
          insert_final_newline = true;
          trim_trailing_whitespace = true;
        };

        "*.nix" = {
          indent_style = "space";
          indent_size = 2;
        };

        "*.lock" = {
          indent_style = "unset";
        };

        "*.el" = {
          indent_style = "space";
        };

        "*.zig\.*" = {
          indent_style = "space";
          indent_size = 4;
        };
      };
    };

    programs = {
      bottom.enable = true;
      lsd.enable = true;
      tealdeer.enable = true;

      bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batgrep
          batman
        ];
      };

      direnv = {
        enable = true;
        enableBashIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;

        nix-direnv.enable = true;

        config.global = {
          warn_timeout = "1m";
        };
      };

      gh = {
        enable = true;
        gitCredentialHelper.enable = true;

        settings = {
          git_protocol = "ssh";
          prompt = "enabled";
        };
      };

      git = {
        enable = true;

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

        ignores = [
          ".direnv"
        ];
      };

      jujutsu = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;

        package = inputs.jujutsu.packages.${system}.jujutsu;

        settings = {
          git.auto-local-branch = true;
        };
      };

      nix-index = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };

      skim = {
        enable = true;
        enableBashIntegration = true;
        # TODO: enableNushellIntegration = true;
        enableZshIntegration = true;

        defaultCommand = "fd --type f || find .";
        defaultOptions = [
          "--preview 'bat --color=always --line-range=:500 {}'"
        ];
      };

      zoxide = {
        enable = true;
        enableBashIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
      };
    };
  };
}

