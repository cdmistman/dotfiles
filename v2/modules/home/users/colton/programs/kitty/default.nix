{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mistman.users.colton;
in

lib.mkIf (cfg.enable && cfg.gui) {
  home.packages = [
    pkgs.kitty
  ];

  xdg.configFile.kitty = {
    enable = true;
    source = pkgs.symlinkJoin {
      name = "kitty-config";
      recursive = true;
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

