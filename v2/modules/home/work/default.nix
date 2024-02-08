{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mistman.work;
in

{
  options.mistman.work = {
    enable = mkEnableOption "Some work-only configurations";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      docker
    ];
  };
}

