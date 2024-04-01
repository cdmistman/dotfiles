{
  description = "cdmistman's rewritten dotfiles using Snowfall.";

  inputs = {
    # kinda sick of git breaking semi-often tbh...
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # it's a snowfall flake
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils-plus.follows = "flake-utils-plus";
    };

    # config inputs
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # personal inputs
    nvim = {
      url = "github:cdmistman/nvim";
      inputs.fenix.follows = "fenix";
      inputs.flake-parts.follows = "flake-parts";
      inputs.neovim-nightly-overlay.follows = "neovim-nightly-overlay";
      inputs.nixd.follows = "nixd";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.tokyonight-nvim.follows = "tokyonight";
    };

    tokyonight = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };

    # util inputs
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat.url = "github:edolstra/flake-compat";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    flake-utils-plus = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
      inputs.flake-utils.follows = "flake-utils";
    };

    hercules-ci-effects = {
      url = "github:hercules-ci/hercules-ci-effects";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim = {
      url = "github:neovim/neovim/v0.9.5?dir=contrib";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      inputs.hercules-ci-effects.follows = "hercules-ci-effects";
      inputs.neovim-flake.follows = "neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixd = {
      url = "github:nix-community/nixd";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: manage with niv?
    # neovim plugins
    aerial-nvim = {
      url = "github:stevearc/aerial.nvim";
      flake = false;
    };

    bufferline-nvim = {
      url = "github:akinsho/bufferline.nvim/v4.5.0";
      flake = false;
    };

    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };

    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };

    cmp-nvim-lsp-document-symbol = {
      url = "github:hrsh7th/cmp-nvim-lsp-document-symbol";
      flake = false;
    };

    cmp-nvim-lsp-signature-help = {
      url = "github:hrsh7th/cmp-nvim-lsp-signature-help";
      flake = false;
    };

    cmp_luasnip = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };

    comment-nvim = {
      url = "github:numToStr/Comment.nvim";
      flake = false;
    };

    copilot-lua = {
      url = "github:zbirenbaum/copilot.lua";
      flake = false;
    };

    copilot-cmp = {
      url = "github:zbirenbaum/copilot-cmp";
      flake = false;
    };

    direnv-vim = {
      url = "github:direnv/direnv.vim";
      flake = false;
    };

    flash-nvim = {
      url = "github:folke/flash.nvim";
      flake = false;
    };

    hydra-nvim = {
      url = "github:anuvyklack/hydra.nvim";
      flake = false;
    };

    luasnip = {
      url = "github:L3MON4D3/LuaSnip/v2.2.0";
      flake = false;
    };

    neoscroll-nvim = {
      url = "github:karb94/neoscroll.nvim";
      flake = false;
    };

    neo-tree-nvim = {
      url = "github:nvim-neo-tree/neo-tree.nvim?ref=3.17";
      flake = false;
    };

    noice-nvim = {
      url = "github:folke/noice.nvim";
      flake = false;
    };

    nui-nvim = {
      url = "github:MunifTanjim/nui.nvim";
      flake = false;
    };

    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };

    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };

    nvim-notify = {
      url = "github:rcarriga/nvim-notify";
      flake = false;
    };

    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };

    nvim-treesitter-context = {
      url = "github:nvim-treesitter/nvim-treesitter-context";
      flake = false;
    };

    nvim-web-devicons = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };

    peek-nvim = {
      url = "github:toppair/peek.nvim";
      flake = false;
    };

    persistence-nvim = {
      url = "github:folke/persistence.nvim";
      flake = false;
    };

    plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    rustaceanvim = {
      url = "github:mrcjkb/rustaceanvim/4.13.0";
      flake = false;
    };

    startup-nvim = {
      url = "github:cdmistman/startup.nvim/patch-1";
      flake = false;
    };

    substitute-nvim = {
      url = "github:gbprod/substitute.nvim";
      flake = false;
    };

    telescope-nvim = {
      url = "github:nvim-telescope/telescope.nvim?ref=0.1.5";
      flake = false;
    };

    todo-comments-nvim = {
      url = "github:folke/todo-comments.nvim";
      flake = false;
    };

    which-key-nvim = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };

    yanky-nvim = {
      url = "github:gbprod/yanky.nvim";
      flake = false;
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;
      snowfall.namespace = "mistman";

      overlays = [
        inputs.fenix.overlays.default
        inputs.nixd.overlays.default
        (import (inputs.home-manager + /overlay.nix))
      ];

      channels-config = {
        allowUnfree = true;
      };

      outputs-builder = channels: {
        formatter = channels.nixpkgs.alejandra;
      };

      homes.users."colton@donn-replit-devvm".modules = [
        inputs.nix-index-db.hmModules.nix-index
      ];

      systems.modules.darwin = [
        {
          home-manager = {
            useGlobalPkgs = true;

            sharedModules = [
              inputs.nix-index-db.hmModules.nix-index
            ];
          };
        }
      ];

      systems.hosts.donn-dev.modules = [
        {
          networking = {
            computerName = "donn-dev server";
            hostName = "donn-dev";
          };
        }
      ];

      systems.hosts.donn-mbp.modules = [
        {
          networking = {
            computerName = "Colton’s MacBook Pro";
            hostName = "donn-mbp";
          };
        }
      ];

      systems.hosts.donn-replit-mbp.modules = [
        {
          networking = {
            computerName = "Colton’s Replit MacBook Pro";
            hostName = "donn-replit-mbp";
          };
        }
      ];
    };
}
