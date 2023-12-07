{
  inputs,
  lib,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.kitty
  ];

  xdg.configFile.kitty = {
    enable = true;
    source = pkgs.symlinkJoin {
      name = "kitty-config";
      paths = let
        my-conf = builtins.path { path = ./.; filter = (path: _: (builtins.baseNameOf path) != "default.nix"); };

        themes = pkgs.stdenvNoCC.mkDerivation {
          name = "kitty-themes";
          buildCommand = ''
            mkdir -p $out/themes
            for theme in ${inputs.tokyonight}/extras/kitty/*; do
              local theme_name=$(basename $theme)
              ln -s $theme $out/themes/$theme_name
            done
          '';
        };
      in [ my-conf themes ];
    };
  };
}

