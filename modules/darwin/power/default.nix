{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) toString;
  inherit (lib) filterAttrs mapAttrsToList mkOption mkIf types;

  mkPowerOption = opts:
    mkOption ({
        type = types.nullOr types.int;
        default = null;
        defaultText = "null";
      }
      // opts);

  pmset = {
    name,
    value,
  }: "pmset -a ${name} ${toString value}";

  cfg = config.powermanager;
in {
  options.powermanager = {
    autorestart = mkPowerOption {};
    disksleep = mkPowerOption {};
    displaysleep = mkPowerOption {};
    lowpowermode = mkPowerOption {};
    networkoversleep = mkPowerOption {};
    powernap = mkPowerOption {};
    sleep = mkPowerOption {};
    standby = mkPowerOption {};
    tcpkeepalive = mkPowerOption {};
    ttyskeepalive = mkPowerOption {};
    womp = mkPowerOption {};
  };

  config.system.activationScripts.pmsetOptions.text = ''
    ${mapAttrsToList pmset (filterAttrs (_: v: v != null) cfg)}
  '';
}
