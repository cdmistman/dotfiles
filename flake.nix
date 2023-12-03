{
  description = "My (cdmistman/colton) Nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mkAlias = {
      url = "github:reckenrode/mkAlias";
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

    nvim = {
      url = "github:cdmistman/nvim";
      inputs.fenix.follows = "fenix";
      inputs.nixd.follows = "nixd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    home-manager,
    nixpkgs,
    ...
  }: {
    darwinConfigurations = {
      donn-mbp = import ./system/darwin {
        inherit inputs;

        system = "aarch64-darwin";

        modules = [
          {
            networking = {
              computerName = "Colton’s MacBook Pro";
              hostName = "donn-mbp";
            };
          }
        ];
      };

      donn-replit-mbp = import ./system/darwin {
        inherit inputs;

        system = "aarch64-darwin";

        modules = [
          {
            home-manager.users.colton = {pkgs, ...}: {
              # TODO: get nixpkgs-packaged google-cloud-sdk working
              home.sessionPath = [
                "$HOME/.google-cloud-sdk/bin"
              ];

              home.sessionVariables = {
                CLOUDSDK_PYTHON = "${pkgs.python3.withPackages (ps: with ps; [numpy])}/bin/python3";
                CLOUDSDK_PYTHON_SITEPACKAGES = "1";
                CLOUDSDK_LOCATION = "$HOME/.google-cloud-sdk";
              };
            };

            networking = {
              computerName = "Colton’s Replit MacBook Pro";
              hostName = "donn-replit-mbp";
            };
          }
        ];
      };
    };

    homeConfigurations.replit-devvm = let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit inputs system;

          enableGUI = false;
        };

        modules = [
          (import ./home/colton)
          {
            home.homeDirectory = "/home/colton";
          }
        ];
      };
  };
}
