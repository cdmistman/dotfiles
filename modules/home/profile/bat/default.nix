{ config, inputs, lib, pkgs, ... }: lib.mkIf config.mistman.profile.enable {
  home = {
    sessionVariables.MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    sessionVariables.MANROFFOPT = "-c";
    sessionVariables.PAGER = "bat";
    shellAliases.man = "batman";
  };

  programs.bat = {
    extraPackages = with pkgs.bat-extras; [
      batman
    ];
  };

  xdg.configFile.bat.source = let
    tokyonight-themes = pkgs.runCommand "bat-tokyonight-themes" {} ''
      mkdir -p $out/themes
      for theme in ${inputs.tokyonight}/extras/sublime/*; do
        local theme_name=$(basename $theme)
        ln -s $theme $out/themes/$theme_name
      done
    '';

    filterNix = path: _: ! lib.hasSuffix ".nix" path;
    here = builtins.filterSource filterNix ./.;
  in pkgs.symlinkJoin {
    name = "bat-config";
    recursive = true;
    paths = [ tokyonight-themes here ];
  };
}
