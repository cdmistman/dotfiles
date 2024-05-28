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
  inherit (lib.home-manager.hm) dag;

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
  # kitty = pkgs.runCommand "kitty-wrapped" {
  #   nativeBuildInputs = [ pkgs.makeWrapper ];
  # } ''
  #   set -e
  #
  #   mkdir $out
  #   ${pkgs.rsync}/bin/rsync -avl --perms --chmod=+w --chown=$USER ${pkgs.kitty}/* $out
  #
  #   flags=(
  #     --single-instance
  #     --instance-group ${config-hash}
  #     --listen-on unix:/tmp/kitty.sock
  #     -o allow_remote_control=yes
  #   )
  #
  #   wrapProgram $out/bin/kitty --add-flags "''${flags[*]}"
  #
  #   ${optionalString pkgs.stdenv.isDarwin ''
  #     wrapProgram $out/Applications/kitty.app/Contents/MacOS/kitty \
  #       --add-flags "$flags"
  #   ''}
  # '';
in
  lib.mkIf config.mistman.profile.enable {
    home.packages = optional cfg.gui-apps pkgs.kitty;

    services.dark-mode-notify.scripts.kitty = dag.entryAnywhere ''
      os_theme_path="$HOME/.config/kitty/themes/os.conf"

      [[ -e "$os_theme_path" ]] && unlink "$os_theme_path"

      if [[ "$DARKMODE" == "1" ]]; then
        echo "kitty dark mode"
        ln -s $HOME/.config/kitty/themes/tokyonight_night.conf "$os_theme_path"
      else
        echo "kitty light mode"
        ln -s $HOME/.config/kitty/themes/tokyonight_day.conf "$os_theme_path"
      fi

      ${pkgs.kitty}/bin/kitten @ --to unix:/tmp/kitty.sock load-config
    '';

    xdg.configFile.kitty = {
      recursive = true;
      source = let
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
    };
  }
