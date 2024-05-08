{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) importTOML mkEnableOption mkIf;

  email = "colton@donn.io";
  name = "Colton Donnelly";

  themes-data =
    pkgs.runCommand "my-themes-dir" {
      buildInputs = [
        pkgs.neovim-unwrapped
        pkgs.yq
      ];
    } ''
      tmp=$(mktemp -d)
      mkdir -p $tmp
      pushd $tmp
      cp -r ${inputs.tokyonight.outPath}/* .
      chmod -R +w .
      rm lua/tokyonight/extra/*
      cp -r ${./patches/tokyonight}/* lua/tokyonight/extra
      eval $(yq -r '.jobs.extras.steps | map(select(.name == "Build Extras"))[0].run' "${inputs.tokyonight.outPath}/.github/workflows/ci.yml")
      popd

      mv $tmp/extras/coolton $out
    '';

  tokyonight-theme.dark = importTOML "${themes-data.outPath}/tokyonight_night.toml";

  cfg = config.mistman.profile;
in {
  imports = [
    ./alacritty.nix
    ./bat
    ./direnv.nix
    ./editorconfig.nix
    ./kitty
    ./process-compose.nix
    ./ssh.nix
    ./starship
    ./zsh.nix
  ];

  options.mistman.profile = {
    enable = mkEnableOption "my home dir configuration";
    alacritty = mkEnableOption "alacritty package" // {default = cfg.enable;};
    gui-apps = mkEnableOption "GUI application packages";
    vscode = mkEnableOption "vscode package" // {default = cfg.enable;};
  };

  config = mkIf cfg.enable {
    editorconfig.enable = true;
    xdg.enable = true;

    _module.args.theme = {
      dark = tokyonight-theme.dark;
      light = tokyonight-theme.light;
    };

    home = {
      stateVersion = "23.11";
      username = "colton";

      packages = with pkgs; [
        _1password
        cachix
        comma
        difftastic
        du-dust
        fswatch
        home-manager
        jless
        jq
        niv
        procs
        ripgrep
        sd
        tokei
        watchman
      ];

      sessionPath = [
        "$HOME/bin"
      ];

      sessionVariables = {
        PAGER = "less -RF";
      };

      shellAliases = {
        k = "clear";
        kn = "clear && printf '\\e[3J'";
        l = "ls";
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
      bat.enable = true;
      bottom.enable = true;
      eza.enable = true;
      gh.enable = true;
      git.enable = true;
      jujutsu.enable = true;
      direnv.enable = true;
      nix-index.enable = true;
      process-compose.enable = true;
      skim.enable = true;
      ssh.enable = true;
      starship.enable = true;
      tealdeer.enable = true;
      vscode.enable = cfg.vscode;
      zoxide.enable = true;
      zsh.enable = true;

      bash = {
        enableCompletion = true;
        historyIgnore = [
          "exit"
        ];
      };

      eza = {
        enableBashIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
        extraOptions = ["--group-directories-first"];
        icons = true;
        git = true;
      };

      gh = {
        gitCredentialHelper.enable = true;

        settings = {
          git_protocol = "ssh";
          prompt = "enabled";
        };
      };

      git = {
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
          core.fsmonitor = true;
          core.untrackedcache = true;
          init.defaultBranch = "main";
          pull.rebase = false;
          push.autoSetupRemote = true;
          url."ssh://git@github.com".insteadOf = "github";
        };

        ignores = [
          ".direnv"
        ];
      };

      jujutsu.package = pkgs.jujutsu.override {
        rustPlatform.buildRustPackage = args: let
          overridenArgs =
            args
            // {
              version = inputs.jujutsu-version;
              src = inputs.jujutsu.outPath;
              cargoHash = "sha256-o5r4U2TImdwoVJ48gdHhK8/ct+INDyK+ka8ORkmVnGU=";
            };
        in
          pkgs.rustPlatform.buildRustPackage overridenArgs;
      };

      jujutsu.settings = {
        core = {
          fsmonitor = "watchman";
        };

        git = {
          push-branch-prefix = "cad/push-";
        };

        ui = {
          default-command = "status";
          diff.tool = ["difft" "--color=always" "$left" "$right"];
          editor = "nvim";
        };

        user = {
          inherit email name;
        };
      };

      nix-index = {
        enableBashIntegration = true;
        enableZshIntegration = true;
      };

      skim = {
        enableBashIntegration = true;
        enableZshIntegration = true;
        defaultOptions = let
          fzf_default_opts = pkgs.runCommand "FZF_DEFAULT_OPTS.txt" {} ''
            source "${inputs.tokyonight}/extras/fzf/tokyonight_night.zsh"
            echo "$FZF_DEFAULT_OPTS" >$out
          '';
        in [
          (builtins.readFile fzf_default_opts)
          # "--preview 'bat --color=always --line-range=:500 {}'"
        ];
      };

      zoxide = {
        enableBashIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
      };
    };

    services.dark-mode-notify.enable = true;
  };
}
