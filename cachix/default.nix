{
  imports = [
    ./colton.nix
    ./devenv.nix
    ./nix-community.nix
    ./pre-commit-hooks.nix
  ];

  nix.settings.substituters = [
    # included by default with environment.systemPackages i guess
    # "https://cache.nixos.org/"
  ];
}
