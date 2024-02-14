{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mistman.owned;
in

{
  options.mistman.owned = {
    enable = mkEnableOption "configurations for my owned darwin machines";
  };

  config = lib.mkIf cfg.enable {
    environment = {
      loginShell = "/bin/zsh";

      systemPackages = with pkgs; [
        cachix
      ];
    };

    fonts = {
      fontDir.enable = true;

      fonts = [
        (pkgs.nerdfonts.override {
          fonts = [
            "FiraCode"
            "FiraMono"
            "Hack"
          ];
        })
      ];
    };

    nix.settings = {
      auto-optimise-store = true;
      experimental-features = "nix-command flakes";
      sandbox = false;
      trusted-users = [ "root" "colton" "admin" ];
    };

    programs = {
      bash.enable = true;
      zsh.enable = true;
    };

    # TODO: services.cachix-agent.enable = true;
    services.nix-daemon.enable = true;

    users.users.colton = {
      createHome = true;
      description = "coolton";
      gid = 20;
      home = "/Users/colton";

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMO+PKzr+JszoCzGtsvMH1tdNwRucTuRcKysPx1fTDmp colton@donn.io"
      ];

      shell = "${pkgs.zsh}/bin/zsh";
      uid = 601;
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

