{pkgs, ...}: {
  nix = {
    package = pkgs.nixVersions.nix_2_16;

    registry.my = {
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

    settings = {
      auto-optimise-store = true;

      experimental-features = "nix-command flakes";

      sandbox = true;

      trusted-users = ["root" "colton"];
    };
  };
}
