{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.home-manager.lib) hm;
  inherit (lib) mkIf mkEnableOption;
in {
  options.darwin-trampolines.enable = mkEnableOption "darwin-trampolines";

  # Thanks pperanich! https://github.com/nix-community/home-manager/issues/1341#issuecomment-1870352014
  config = mkIf config.darwin-trampolines.enable {
    home = {
      # Install MacOS applications to the user Applications folder. Also update Docked applications
      extraActivationPath = with pkgs; [
        rsync
        dockutil
        gawk
      ];

      activation.trampolineApps = hm.dag.entryAfter ["writeBoundary"] ''
        . ${./trampoline-apps.sh}

        fromDir="$HOME/Applications/Home Manager Apps"
        toDir="$HOME/Applications/Home Manager Trampolines"
        sync_trampolines "$fromDir" "$toDir"
      '';
    };
  };
}
