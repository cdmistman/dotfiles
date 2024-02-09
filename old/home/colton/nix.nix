{ inputs, lib, pkgs, ... }: {
  nixpkgs.config = {
    allowUnfree = true;
  };

  nixpkgs.overlays = [
    inputs.fenix.overlays.default
    inputs.nixd.overlays.default
  ];

  nix.package = lib.mkDefault pkgs.nixVersions.nix_2_18;

  nix.registry.me = {
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
