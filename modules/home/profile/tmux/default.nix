{
  lib,
  pkgs,
  ...
}: {
  home.packages = [pkgs.tmux];

  xdg.configFile."tmux" = {
    recursive = true;

    source = let
      filterNix = path: _: ! lib.hasSuffix ".nix" path;
      here = builtins.filterSource filterNix ./.;
    in
      pkgs.symlinkJoin {
        name = "tmux-config";
        recursive = true;
        paths = [here];
      };
  };
}
