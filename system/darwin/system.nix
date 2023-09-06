{
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
}
