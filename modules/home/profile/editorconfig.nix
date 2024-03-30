{
  config,
  lib,
  ...
}:
lib.mkIf (config.mistman.profile.enable) {
  editorconfig.settings = {
    "*" = {
      charset = "utf-8";
      end_of_line = "lf";
      indent_size = 2;
      insert_final_newline = true;
      trim_trailing_whitespace = true;
    };

    "*.nix" = {
      indent_style = "space";
      indent_size = 2;
    };

    "*.lock" = {
      indent_style = "unset";
    };

    "*.el" = {
      indent_style = "space";
    };

    "*.{zig,zon}" = {
      indent_style = "space";
      indent_size = 4;
    };
  };
}
