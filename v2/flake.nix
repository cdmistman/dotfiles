{
  description = "cdmistman's rewritten dotfiles using Snowfall.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # it's a snowfall flake
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.nixd.follows = "nixd";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.tokyonight-nvim.follows = "tokyonight";
    };

    tokyonight.url = "github:folke/tokyonight.nvim";

    # util inputs
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixd = {
      url = "github:nix-community/nixd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;
      snowfall.namespace = "mistman";

      channels-config = {
        allowUnfree = true;

        overlays = [
          inputs.fenix.overlays.default
          inputs.nixd.overlays.default
        ];
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

      # systems.modules = [
      #   inputs.home-manager.darwinModules.home-manager
      # ];
    };
}
