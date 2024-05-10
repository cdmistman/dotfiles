{ config, lib, theme, ... }:

let
  cfg = config.mistman.profile;

  inherit (lib) mkIf;
in

{
  config = mkIf cfg.enable {
    programs.process-compose = {
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
