{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.mistman.profile;

  inherit (builtins) map;
  inherit (lib) attrsToList foldr optional optionalString substring;

  hash-file = path: builtins.hashFile "sha256" (./. + "/${path}");

  hash-dir = path:
    lib.pipe (builtins.readDir path) [
      attrsToList
      (map ({
        name,
        value,
      }:
        if value == "regular"
        then hash-file name
        else if value == "directory"
        then hash-dir name
        else throw ("unhandled hash-dir filetype arg at path " + name + ": " + value)))
      (foldr (hash: acc: builtins.hashString "sha256" (hash + acc)) "")
    ];

  config-hash = substring 0 6 (hash-dir ./.);

  kitty = pkgs.kitty.overrideAttrs (old: {
    nativeBuildInputs =
      old.nativeBuildInputs
      ++ [
        pkgs.makeWrapper
      ];

    postInstall =
      (old.postInstall or "")
      + ''
        flags='--single-instance --instance-group ${config-hash}'

        wrapProgram $out/bin/kitty \
          --add-flags '--single-instance --instance-group ${config-hash}'

        ${optionalString pkgs.stdenv.isDarwin ''
          wrapProgram $out/Applications/kitty.app/Contents/MacOS/kitty \
        ''}
      '';
  });
in
  lib.mkIf config.mistman.profile.enable {
    home.packages = optional cfg.gui-apps kitty;

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
