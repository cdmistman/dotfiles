{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mistman.work;
in {
  options.mistman.work = {
    enable = mkEnableOption "Some work-only configurations";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        docker
      ];

      # TODO: get nixpkgs-packaged google-cloud-sdk working
      sessionPath = [
        "$HOME/.google-cloud-sdk/bin"
      ];

      sessionVariables = {
        CLOUDSDK_PYTHON = "${pkgs.python3.withPackages (ps: with ps; [numpy])}/bin/python3";
        CLOUDSDK_PYTHON_SITEPACKAGES = "1";
        CLOUDSDK_LOCATION = "$HOME/.google-cloud-sdk";
      };
    };
  };
}
