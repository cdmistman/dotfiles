{
  description = "cdmistman's rewritten dotfiles using Snowfall.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./.;

      snowfall = {
        namespace = "dots";

        meta = {
          name = "dotfiles";
          title = "cdmistman's dotfiles";
        };
      };
    };
  in
    lib.mkFlake {
      outputs-builder = channels: {
        formatter = channels.nixpkgs.alejandra;
      };
    };
}
