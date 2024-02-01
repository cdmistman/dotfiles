{
  description = "cdmistman's rewritten dotfiles using Snowfall.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;
      snowfall.namespace = "dots";

      outputs-builder = channels: {
        formatter = channels.nixpkgs.alejandra;
      };
    };
}
