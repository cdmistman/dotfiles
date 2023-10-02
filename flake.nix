{
  description = "My (cdmistman/colton) Nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    auto-save-nvim = {
      url = "github:okuuva/auto-save.nvim";
      flake = false;
    };

    bufferline-nvim = {
      url = "github:akinsho/bufferline.nvim";
      flake = false;
    };

    comment-nvim = {
      url = "github:numToStr/comment.nvim";
      flake = false;
    };

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

    neoscroll-nvim = {
      url = "github:karb94/neoscroll.nvim";
      flake = false;
    };

    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noice-nvim = {
      url = "github:folke/noice.nvim";
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

    neo-tree-nvim = {
      url = "github:nvim-neo-tree/neo-tree.nvim/v3.x";
      flake = false;
    };

    nvim-treesitter-context = {
      url = "github:nvim-treesitter/nvim-treesitter-context";
      flake = false;
    };

    rust-tools-nvim = {
      url = "github:simrat39/rust-tools.nvim";
      flake = false;
    };

    telescope-nvim = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };

    twilight-nvim = {
      url = "github:folke/twilight.nvim";
      flake = false;
    };

    which-key-nvim = {
      url = "github:folke/which-key.nvim";
      flake = false;
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
