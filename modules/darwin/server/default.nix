{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mistman.server;
in {
  options.mistman.server = {
    enable = mkEnableOption "my darwin server configurations";
  };

  config = mkIf cfg.enable {
    nix.daemonIOLowPriority = true;

    # TODO: services.eternal-terminal.enable = true;
  };
}
