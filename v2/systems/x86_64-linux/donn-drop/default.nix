{lib, pkgs, ...}:
with lib.dots; {
  # networking.hostname = "donn-drop";

  # NOTE: never need to change this
  system.stateVersion = "23.11";

  environment.systemPackages = [
    pkgs.neovim
  ];

  dots = {
    nixosModules = {
      digitalocean = enabled;
    };
  };
}
