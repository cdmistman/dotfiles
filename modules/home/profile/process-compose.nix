{ config, lib, pkgs, theme, ... }:

let
  cfg = config.mistman.profile;

  inherit (lib) mkIf;

  patches = {
    some-more-styles = pkgs.fetchpatch2 {
      url = "https://patch-diff.githubusercontent.com/raw/F1bonacc1/process-compose/pull/182.patch";
      sha256 = "sha256-6bl2RtXy+YX6lDe3zGA5coKXQ0/p6PZTWs3UAE4bkXk=";
    };
  };

  package = pkgs.process-compose.overrideAttrs (old: {
    version = old.version + "-patched";

    patches = (old.patches or []) ++ [
      patches.some-more-styles
    ];

    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
      pkgs.makeWrapper
    ];

    postInstall = ''
      ${old.postInstall or ""}

      makeWrapper $out/bin/process-compose $out/bin/my-process-compose
    '';
  });
in

{
  config = mkIf cfg.enable {
    programs.process-compose = {
      inherit package;

      themes."*" = with theme.dark; {
        body = {
          fgColor = fg.primary;
          bgColor = bg.dark;
          secondaryTextColor = fg.dark;
          tertiaryTextColor = fg.visual;
          borderColor = border.primary;
        };

        stat_table = {
          keyFgColor = color.yellow;
          valueFgColor = color.white;
          logoColor = color.yellow;
        };

        proc_table = {
          fgColor = color.blue;
          fgWarning = color.yellow;
          fgPending = color.dark3;
          fgCompleted = color.green;
          fgError = color.red1;
          headerFgColor = color.white;
        };

        help = {
          fgColor = color.black;
          keyColor = color.white;
          hlColor = color.green;
          categoryFgColor = color.blue5;
        };

        dialog = {
          fgColor = color.blue1;
          bgColor = color.black;
          contrastBgColor = bg.primary;
          attentionBgColor = color.red1;
          buttonFgColor = color.black;
          buttonBgColor = border.inactive;
          buttonFocusFgColor = color.black;
          buttonFocusBgColor = color.blue;
          labelFgColor = color.yellow;
          fieldFgColor = color.black;
          fieldBgColor = color.blue7;
        };
      };
    };
  };
}
