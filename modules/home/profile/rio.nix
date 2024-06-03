{ pkgs, ... }: {
  programs.rio = {
    package = pkgs.rio.overrideAttrs (prev: {
      meta = prev.meta // {
        broken = false;
      };
    });

    settings = {
      editor = "nvim";
      cursor = "▇";
      blinking-cursor = false;

      window = {
        mode = "Fullscreen";
        decorations = "Buttonless";
      };

      fonts = {
        family = "FiraCode Nerd Font";
        size = 20;
      };

      scroll = {
        multiplier = 3.0;
        divider = 2.0;
      };

      navigation = {
        mode = "CollapsedTab";
        use-current-path = true;
        # TODO: would be cool to have color-automation
        # "color-automation" - Set a specific color for the tab whenever a specific program is running, or in a specific directory.
      };
    };
  };
}
