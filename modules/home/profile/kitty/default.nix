{ config, lib, inputs, pkgs, ... }: lib.mkIf config.mistman.profile.enable {
  xdg.configFile.kitty.source = pkgs.symlinkJoin {
    name = "kitty-config";
    recursive = true;
    paths = let
      themes = pkgs.stdenvNoCC.mkDerivation {
        name = "kitty-themes";
        buildCommand = ''
          mkdir -p $out/themes
          for theme in ${inputs.tokyonight}/extras/kitty*; do
            local theme_name=$(basename $theme)
            ln -s $theme $out/themes/$theme_name
          done
        '';
      };

      filterNix = path: _: lib.hasSuffix ".nix" path;
      here = builtins.filterSource filterNix ./.;
    in [themes here];
  };
}
