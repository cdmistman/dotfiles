{
  inputs,
  ...
}: {
  programs.kitty = {
    enable = true;

    extraConfig = "include my_config.conf";

    font = {
      name = "Fira Code Retina";
      size = 14;
    };

    shellIntegration = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };

  xdg.configFile."kitty/my_config.conf" = {
    enable = true;
    source = ./my_config.conf;
  };

  xdg.configFile."kitty/themes" = {
    enable = true;
    source = "${inputs.tokyonight}/extras/kitty";
    recursive = true;
  };
}

