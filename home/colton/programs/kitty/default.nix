{
  inputs,
  pkgs,
  ...
}: {
  # programs.kitty = {
  #   enable = true;
  #
  #   extraConfig = "include my_config.conf";
  #
  #   font = {
  #     name = "Fira Code Retina";
  #     size = 14;
  #   };
  #
  #   shellIntegration = {
  #     enableBashIntegration = true;
  #     enableZshIntegration = true;
  #   };
  # };
  home.packages = [
    pkgs.kitty
  ];

  xdg.configFile."kitty/kitty.conf" = {
    enable = true;
    source = ./kitty.conf;
  };

  xdg.configFile."kitty/themes" = {
    enable = true;
    source = "${inputs.tokyonight}/extras/kitty";
    recursive = true;
  };
}

