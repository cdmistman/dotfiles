{
  editorconfig = {
    enable = true;

    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        indent_size = 2;
        insert_final_newline = true;
        trim_trailing_whitespace = true;
      };

      "*.nix" = {
        indent_style = "space";
      };

      "*.lock" = {
        indent_style = "unset";
      };

      "*.el" = {
        indent_style = "space";
      };

      "*.zig\.*" = {
        indent_style = "space";
        indent_size = 4;
      };
    };
  };
}
