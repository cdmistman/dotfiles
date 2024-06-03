{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mistman.profile;
in {
  options.mistman.profile = {
    enable = mkEnableOption "Enable mistman's darwin system standard profile";
  };

  config = mkIf cfg.enable {
    environment = {
      loginShell = "/bin/zsh";
    };

    fonts.packages = [
      (pkgs.nerdfonts.override {
        fonts = [
          "FiraCode"
          "FiraMono"
          "Hack"
        ];
      })
    ];

    nix = {
      package = pkgs.nixVersions.nix_2_21;
      settings = {
        auto-optimise-store = true;
        experimental-features = "nix-command flakes";
        sandbox = false;
        trusted-users = ["root" "colton" "admin"];
      };
    };

    programs = {
      bash.enable = true;
      zsh.enable = true;
    };

    security.pam.enableSudoTouchIdAuth = true;

    services.nix-daemon.enable = true;
    services.tailscale.enable = true;

    system.keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };

    users.users.admin = {
      description = "Admin user";
      home = "/Users/admin";
      isHidden = false;
    };

    users.users.colton = {
      description = "coolton";
      gid = 20;
      home = "/Users/colton";
      shell = "${pkgs.zsh}/bin/zsh";
      uid = 601;

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMO+PKzr+JszoCzGtsvMH1tdNwRucTuRcKysPx1fTDmp colton@donn.io"
      ];
    };

    system.defaults = {
      NSGlobalDomain = {
        AppleEnableMouseSwipeNavigateWithScrolls = true;
        AppleEnableSwipeNavigateWithScrolls = true;

        AppleInterfaceStyle = "Dark";

        AppleShowAllFiles = true;
        AppleShowScrollBars = "Always";

        NSDocumentSaveNewDocumentsToCloud = false;

        "com.apple.keyboard.fnState" = false;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = true;
        showhidden = true;
        tilesize = 40;
      };

      finder = {
        AppleShowAllFiles = true;

        CreateDesktop = false;

        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "clmv";

        QuitMenuItem = false;

        ShowPathbar = true;
        ShowStatusBar = true;
      };

      magicmouse.MouseButtonMode = "TwoButton";

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = false;
      };
    };
  };
}
