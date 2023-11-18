args @ {
  config,
  lib,
  modulesPath,
  ...
}:
with lib; let
  cfg = config.nixpkgs-profiles.qemu-guest;
  modPath = modulesPath + "/profiles/qemu-guest.nix";
  mod = import modPath args;
in {
  options.nixpkgs-profiles.qemu-guest.enable = mkEnableOption (mdDoc "Enable QEMU guest profile from nixpkgs.");

  config = mkIf cfg.enable mod;
}
