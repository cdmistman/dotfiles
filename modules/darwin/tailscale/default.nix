{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.tailscale;

  inherit (lib) boolToString mkEnableOption mkIf mkOption types;
in {
  options.tailscale = {
    enable = mkEnableOption "Tailscale connectivity via tailscale up/down";

    up = {
      acceptRoutes = mkOption {
        description = "accept routes advertised by other Tailscale nodes";
        type = types.bool;
        default = false;
      };

      authKey = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          node authorization key; if it begins with \"file:\", then it's a path to a file containing the authkey

          Note that, because this value is inserted in the activation script, it's ok to use an environment
          variable, ie `$MY_SECRET`. This value is passed as-is to the flag
        '';
      };

      ssh = mkOption {
        type = types.bool;
        default = false;
        description = "run an SSH server, permitting access per tailnet admin's declared policy";
      };

      flags = mkOption {
        description = "the generated flags to pass to `tailscale up`";
        readOnly = true;
        type = types.listOf types.string;
        default = [
          "--accept-routes=${lib.boolToString cfg.up.acceptRoutes}"
          (
            if cfg.up.ssh
            then "--ssh"
            else "--ssh=false"
          )
        ]
        ++ lib.optional (cfg.up.authKey != null) "--auth-key ${cfg.up.authKey}";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.tailscale
    ];

    system.activationScripts = {
      preActivation.text = ''
        if [[ -e /var/run/tailscaled.socket ]]; then
          ${pkgs.tailscale}/bin/tailscale down
        fi
      '';

      postActivation.text = ''
        ${pkgs.tailscale}/bin/tailscale up ${builtins.concatStringsSep " " cfg.up.flags}
      '';
    };
  };
}
