{
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.mistman.profile;

  inherit (lib) mkIf;
in {
  config = mkIf cfg.enable {
    programs.process-compose.themeFiles = lib.map (variant: "${inputs.tokyonight}/extras/process_compose/tokyonight_${variant}.yaml") [
      "day"
      "moon"
      "night"
      "storm"
    ];
  };
}
