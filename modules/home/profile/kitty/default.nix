{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
lib.mkIf config.mistman.profile.enable {
  xdg.configFile.kitty.source = let
    tokyonight-themes = pkgs.runCommand "kitty-tokyonight-themes" {} ''
      mkdir -p $out/themes
      for theme in ${inputs.tokyonight}/extras/kitty/*; do
        local theme_name=$(basename $theme)
        ln -s $theme $out/themes/$theme_name
      done
    '';

    filterNix = path: _: ! lib.hasSuffix ".nix" path;
    here = builtins.filterSource filterNix ./.;
  in
    pkgs.symlinkJoin {
      name = "kitty-config";
      recursive = true;
      paths = [tokyonight-themes here];
    };
}
