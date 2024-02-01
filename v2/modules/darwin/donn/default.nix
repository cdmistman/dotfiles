{ config, lib, pkgs, ... }:

let
  cfg = config.mistman.darwin-config;
in

{
  options.mistman.darwin-config.enable = lib.mkEnableOption "darwin-config";

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
      auto-optimize-store = true;
      experimental-features = "nix-command flakes";
      sandbox = false;
      trusted-users = [ "root" ];
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

    system.keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
