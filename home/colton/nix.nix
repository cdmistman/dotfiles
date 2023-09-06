{ lib, pkgs, ... }: {
  nixpkgs.config = {
    allowUnfree = true;
  };

  nix.package = lib.mkDefault pkgs.nixVersions.nix_2_17;

  nix.registry.my = {
    from = {
      type = "indirect";
      id = "my";
    };

    to = {
      type = "github";
      owner = "cdmistman";
      repo = "dotfiles";
    };
  };
}
