{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf optionals;

  email = "colton@donn.io";
  name = "Colton Donnelly";

  cfg = config.mistman.profile;
in {
  imports = [
    ./direnv.nix
    ./editorconfig.nix
    ./kitty
    ./ssh.nix
    ./starship.nix
    ./zsh.nix
  ];

  options.mistman.profile = {
    enable = mkEnableOption "my home dir configuration";
    alacritty = mkEnableOption "alacritty package" // { default = cfg.enable; };
    gui-apps = mkEnableOption "GUI application packages";
    vscode = mkEnableOption "vscode package" // { default = cfg.enable; };
  };

  config = mkIf cfg.enable {
    editorconfig.enable = true;

    mistman = {
      nvim.enable = true;
    };

    home = {
      stateVersion = "23.11";
      username = "colton";

      packages = with pkgs; ([
        cachix
        comma
        du-dust
        fd
        home-manager
        jless
        jq
        procs
        ripgrep
        sd
        tokei
      ] ++ optionals cfg.gui-apps [
        kitty
        obsidian
      ]);

      sessionPath = [
        "$HOME/bin"
      ];

      sessionVariables = {
        MANPAGER = "sh -c 'col -bx | bat -l man -p'";
        MANROFFOPT = "-c";
        PAGER = "bat";
      };

      shellAliases = {
        k = "clear";
        kn = "clear && printf '\\e[3J'";
        l = "ls";
        man = "batman";
      };
    };

    nix = {
      settings.nix-path = ["nixpkgs=${inputs.nixpkgs}"];

      registry.me = {
        from = {
          type = "indirect";
          id = "me";
        };

        to = {
          type = "github";
          owner = "cdmistman";
          repo = "dotfiles";
        };
      };

      registry.nixpkgs = {
        flake = inputs.nixpkgs;
        from = {
          type = "indirect";
          id = "nixpkgs";
        };
      };
    };

    programs = {
      alacritty.enable = cfg.alacritty;
      bash.enable = true;
      bottom.enable = true;
      direnv.enable = true;
      starship.enable = true;
      tealdeer.enable = true;
      vscode.enable = cfg.vscode;
      zsh.enable = true;

      bash = {
        enableCompletion = true;

        historyIgnore = [
          "exit"
        ];
      };

      bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          batman
          batgrep
        ];
      };

      eza = {
        enable = true;
        enableBashIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
        extraOptions = ["--group-directories-first"];
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
        userEmail = email;
        userName = name;

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

        settings.git = {
          auto-local-branch = true;
          push-branch-prefix = "cad/push-";
        };

        settings.ui = {
          default-command = "status";
          editor = "nvim";
        };

        settings.user = {
          inherit email name;
        };
      };

      nix-index = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };

      nushell = {
        enable = true;
        configFile.source = ./nu/config.nu;
        envFile.source = ./nu/env.nu;
        loginFile.source = ./nu/login.nu;
      };

      skim = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        defaultOptions = [
          "--preview 'bat --color=always --line-range=:500 {}'"
        ];
      };

      ssh = {
        enable = true;
        # TODO: enable
        # addKeysToAgent = "yes";
        compression = true;

        controlMaster = "auto";
        controlPath = "~/.ssh/multiplexing/%r@%h:%p";
        controlPersist = "2h";

        hashKnownHosts = true;
        includes = ["config.d/*"];

        matchBlocks = {
          github = {
            hostname = "github.com";
            port = 22;
            user = "git";
          };
        };
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
