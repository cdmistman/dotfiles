{
  inputs,
  pkgs,
  system,
  ...
}: {
  programs.rio = {
    # package = pkgs.rio.override {
    #   rustPlatform.buildRustPackage = arg: let
    #     arg-overrides = {
    #       version = "0.0.39";
    #       src = inputs.rio.outPath;
    #       cargoHash = "sha256-GwI2zHX1YcR4pC+qtkDoxx2U+zipbqqxsCI8/XNg2BU=";
    #     };
    #   in pkgs.rustPlatform.buildRustPackage (arg // arg-overrides);
    # };

    settings = {
      editor = "nvim";
      cursor = "▇";
      blinking-cursor = false;

      window = {
        mode = "Fullscreen";
        decorations = "Buttonless";
      };

      fonts = {
        family = "FiraMono Nerd Font";
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
