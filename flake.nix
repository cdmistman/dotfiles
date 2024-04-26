{
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
      # TODO: use upstream
      url = "github:cdmistman/flake-parts/all-modules";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

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

    ollama = {
      # TODO: use upstream
      url = "github:cdmistman/ollama/nix-flake-darwin-module";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.flake-utils.follows = "flake-parts";
      inputs.systems.follows = "systems";
    };

    systems.url = "github:nix-systems/default";
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;
      snowfall.namespace = "mistman";

      overlays = [
        inputs.fenix.overlays.default
        inputs.neovim-nightly-overlay.overlays.default
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
