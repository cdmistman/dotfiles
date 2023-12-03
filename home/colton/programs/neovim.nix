{
  inputs,
  pkgs,
  system,
  ...
}:

{
  home.packages = [
    inputs.nvim.packages.${system}.neovim-with-plugins
  ];

  xdg.configFile."nvim" = {
    enable = true;
    source = inputs.nvim.packages.${system}.config-dir;
  };
}
