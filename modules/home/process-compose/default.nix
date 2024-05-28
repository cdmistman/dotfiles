{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.process-compose;

  inherit (lib) genAttrs literalExpression mapAttrs' mkEnableOption mkPackageOption mkIf mkOption types;

  toYAML = builtins.toJSON;

  mkColorOption = mkOption {
    description = "the color to use";
    example = "#ff0000";
    type = types.nullOr types.str;
    default = null;
    defaultText = literalExpression "null";
  };

  mkColorOptions = colors: genAttrs colors (_: mkColorOption);
in {
  options.programs.process-compose = {
    enable = mkEnableOption "process-compose";

    package = mkPackageOption pkgs "process-compose" {};

    settings = mkOption {
      description = "the `$XDG_CONFIG_HOME/process-compose/settings.yaml` file";
      default = {};
      type = types.submodule {
        options = {
          sort = {
            by = mkOption {
              description = "the column to use for sorting";
              type = types.str;
              default = "NAME";
            };

            isReversed = mkOption {
              description = "whether to reverse-sort the list";
              type = types.bool;
              default = false;
            };
          };

          theme = mkOption {
            description = ''
              The name of the theme to use.

              Note that the default value changes for you depending on your
              `themes` configuration. When you've set the magic `*` theme, the
              default value here becomes `"Custom Style"`.
            '';
            type = types.string;
            default =
              if cfg.themes ? "*"
              then "Custom Style"
              else "Default";
            defaultText = literalExpression ''if config.process-compose.themes ? "*" then "Custom Style" else "Default"'';
          };
        };
      };
    };

    themes = mkOption {
      description = ''
        Attribute set of themes to put in the `$XDG_CONFIG_HOME/process-compose/themes` directory.

        Note that the special `*` theme can be used to set the default "Custom Style" theme. The
        `name` does not need to be set in this scenario.
      '';
      default = {};
      type = types.attrsOf (types.submodule {
        options = {
          name = mkOption {
            default = null;
            type = types.nullOr types.str;
          };

          body = mkOption {
            default = {};
            type = types.submodule {
              options = mkColorOptions [
                "fgColor"
                "bgColor"
                "secondaryTextColor"
                "tertiaryTextColor"
                "borderColor"
              ];
            };
          };

          stat_table = mkOption {
            default = {};
            type = types.submodule {
              options = mkColorOptions [
                "keyFgColor"
                "valueFgColor"
                "bgColor"
                "logoColor"
              ];
            };
          };

          proc_table = mkOption {
            default = {};
            type = types.submodule {
              options = mkColorOptions [
                "fgColor"
                "fgWarning"
                "fgPending"
                "fgCompleted"
                "fgError"
                "bgColor"
                "headerFgColor"
              ];
            };
          };

          help = mkOption {
            default = {};
            type = types.submodule {
              options = mkColorOptions [
                "keyColor"
                "fgColor"
                "hlColor"
                "categoryFgColor"
              ];
            };
          };

          dialog = mkOption {
            default = {};
            type = types.submodule {
              options = mkColorOptions [
                "fgColor"
                "bgColor"
                "attentionBgColor"
                "contrastBgColor"
                "buttonFgColor"
                "buttonBgColor"
                "buttonFocusFgColor"
                "buttonFocusBgColor"
                "labelFgColor"
                "fieldFgColor"
                "fieldBgColor"
              ];
            };
          };
        };
      });
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.configFile =
      {
        "process-compose/settings.yaml".text = toYAML cfg.settings;
      }
      // mapAttrs' (name: value: {
        name =
          if name == "*"
          then "process-compose/theme.yaml"
          else "process-compose/themes/${name}.yaml";
        value.text = toYAML {style = value;};
      })
      cfg.themes;
  };
}
