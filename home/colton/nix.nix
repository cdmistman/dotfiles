{ lib, pkgs, ... }: {
  nixpkgs.config = {
    allowUnfree = true;
  };

  nix.package = lib.mkDefault pkgs.nixVersions.nix_2_17;

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
