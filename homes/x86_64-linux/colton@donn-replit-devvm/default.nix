{pkgs, ...}: {
  mistman.profile = {
    enable = true;
  };

  nix.package = pkgs.nixVersions.nix_2_18;
}
