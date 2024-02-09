{
  imports = [
    ./colton.nix
    ./nix-community.nix
  ];

  nix.settings.substituters = [
    # included by default with environment.systemPackages i guess
    # "https://cache.nixos.org/"
  ];
}
