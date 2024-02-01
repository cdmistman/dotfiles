{config, lib, ...}: let
  cfg = config.mistman.users.colton;

  setMods = mods:
    builtins.map (
      binding:
        binding // {inherit mods;}
    );
  ctrlOrCmd = (
    binds:
      (setMods "Control|Shift" binds)
      ++ (setMods "Command" binds)
  );
in lib.mkIf (cfg.enable) {
  programs.alacritty = {
    enable = cfg.gui;

    settings.live_config_reload = true;

    settings.cursor = {
      style = {
        shape = "Block";
        blinking = "On";
      };

      unfocused_hollow = true;
    };

    settings.font = {
      normal = {
        family = "FiraCode Nerd Font Mono";
        style = "Regular";
      };

      bold = {
        family = "FiraCode Nerd Font Mono";
        style = "Bold";
      };

      italic = {
        family = "FiraCode Nerd Font Mono";
        style = "Italic";
      };

      bold_italic = {
        family = "FiraCode Nerd Font Mono";
        style = "Bold Italic";
      };

      builtin_box_drawing = false;
      size = 14.0;
    };

    # TODO: hints
    # settings.hints = {};

    settings.key_bindings =
      [
        # window
        {
          key = "F11";
          action = "ToggleFullscreen";
        }
      ]
      ++ (ctrlOrCmd [
        # clipboard
        {
          key = "C";
          action = "Copy";
        }
        {
          key = "V";
          action = "Paste";
        }

        # instances
        {
          key = "N";
          action = "CreateNewWindow";
        }
        # TODO: tabs?
        # { key = "T"; action = "SpawnNewInstance"; }

        # zoom
        {
          key = "Plus";
          action = "IncreaseFontSize";
        }
        {
          key = "Minus";
          action = "DecreaseFontSize";
        }
        {
          key = "Equals";
          action = "ResetFontSize";
        }
      ]);

    settings.mouse.hide_when_typing = true;

    settings.mouse_bindings =
      [
        {
          mouse = "Right";
          action = "ExpandSelection";
        }
      ]
      ++ (ctrlOrCmd [
        {
          mouse = "Middle";
          Mode = "~Vi";
          action = "PasteSelection";
        }
      ]);

    settings.window = {
      decorations = "full";
      decorations_theme_variant = "None";

      dynamic_padding = true;
      dynamic_title = true;

      option_as_alt = "Both";

      startup_mode = "Fullscreen";
    };
  };
}
