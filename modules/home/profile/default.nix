{ config
, inputs
, lib
, pkgs
, ...
}:
let
  inherit (lib) importTOML mkEnableOption mkIf;

  email = "colton@donn.io";
  name = "Colton Donnelly";

  themes-data =
    pkgs.runCommand "my-themes-dir"
      {
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
in
{
  imports = [
    # ./alacritty.nix
    ./bat
    ./direnv.nix
    ./editorconfig.nix
    ./jujutsu.nix
    # ./kitty
    ./process-compose.nix
    ./rio.nix
    ./ssh.nix
    ./starship
    ./tmux
    ./zsh.nix
  ];

  options.mistman.profile = {
    enable = mkEnableOption "my home dir configuration";
    alacritty = mkEnableOption "alacritty package" // { default = cfg.gui-apps; };
    gui-apps = mkEnableOption "GUI application packages";
    vscode = mkEnableOption "vscode package";
  };

  config = mkIf cfg.enable {
    darwin-trampolines.enable = pkgs.stdenv.isDarwin;
    editorconfig.enable = true;
    xdg.enable = true;

    _module.args.theme = {
      dark = tokyonight-theme.dark;
      light = tokyonight-theme.light;
    };

    home = {
      stateVersion = "24.11";
      username = "colton";

      packages =
        (with pkgs; [
          _1password
          cachix
          comma
          difftastic
          du-dust
          fd
          fswatch
          # git-branchless
          home-manager
          jless
          jq
          nil
          niv
          nixpkgs-fmt
          procs
          ripgrep
          sd
          tokei
          watchman
        ])
        ++ (lib.optionals cfg.gui-apps [
          pkgs.discord
        ]);

      sessionPath = [
        "$HOME/bin"
      ];

      shellAliases = {
        k = "clear";
        kn = "clear && printf '\\e[3J'";
        l = "ls";
      };
    };

    nix =
      {
        settings.nix-path = [ "nixpkgs=${inputs.nixpkgs}" ];

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
      }
      // lib.pipe inputs [
        (lib.filterAttrs (_: input: input ? _type && input._type == "flake"))
        (lib.mapAttrs (name: input: {
          flake = input;
          from = {
            type = "indirect";
            id = name;
          };
        }))
        (inputs-reg: { registry = inputs-reg; })
      ];

    nixpkgs.overlays = [
      (self: super:
        let
          rust-toolchain = pkgs.rust-bin.stable.latest;

          new-rustPlatform = pkgs.makeRustPlatform {
            inherit (rust-toolchain) rustc cargo;
          };

          fixed-rustPlatform =
            new-rustPlatform
            // {
              buildRustPackage = args: new-rustPlatform.buildRustPackage args;
            };
        in
        {
          inherit (rust-toolchain) rustc cargo;
          rustPlatform = fixed-rustPlatform;
        })
    ];

    programs = {
      alacritty.enable = cfg.alacritty;
      bash.enable = true;
      bat.enable = true;
      bottom.enable = true;
      eza.enable = true;
      gh.enable = true;
      git.enable = true;
      direnv.enable = true;
      nix-index.enable = true;
      process-compose.enable = true;
      rio.enable = cfg.gui-apps;
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
        extraOptions = [ "--group-directories-first" ];
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
          ".envrc"
          ".watchmanconfig"
        ];
      };

      nix-index = {
        enableBashIntegration = true;
        enableZshIntegration = true;
      };

      skim = {
        enableBashIntegration = true;
        enableZshIntegration = true;
        defaultOptions =
          let
            fzf_default_opts = pkgs.runCommand "FZF_DEFAULT_OPTS.txt" { } ''
              source "${inputs.tokyonight}/extras/fzf/tokyonight_night.sh"
              echo "$FZF_DEFAULT_OPTS" >$out
            '';
          in
          [
            (builtins.readFile fzf_default_opts)
          ];
      };

      zoxide = {
        enableBashIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
      };

      zsh = {
        shellAliases = {
          lt = "eza --tree --git-ignore";
        };
      };
    };

    services = {
      dark-mode-notify.enable = true;
      watchman.enable = true;

      watchman.settings = {
        enforce_root_files = true;
        idle_reap_age_seconds = 86400; # 1 day instead of 5
        prefer_split_fsevents_watcher = true;
        root_files = [ ".git" ".jj" ];
        root_restrict_files = [ ".git" ".jj" ];

        ignore_dirs = [
          ".direnv"
          "node_modules"
          "result"
          "target"
          "zig-cache"
          "zig-out"
        ];
      };
    };
  };
}
