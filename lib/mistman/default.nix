{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  mkDisableOption = description:
    (mkEnableOption description)
    // {
      default = true;
    };
}
