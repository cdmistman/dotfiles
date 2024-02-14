{ config, inputs, lib, pkgs, system, ...}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mistman.extras;
in

{
  options.mistman.extras = {
    enable = mkEnableOption "Some extra configurations. You probably don't want these.";
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

        l = "ls";
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
      tealdeer.enable = true;

      bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          batgrep
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

      eza = {
        enable = true;
        enableAliases = true;
        extraOptions = [ "--group-directories-first" ];
        icons = true;
        git = true;
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

          ui = {
            default-command = "status";
            editor = "nvim";
            diffeditor = "nvim -d";
          };
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

