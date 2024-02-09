{
  inputs,
  pkgs,
  system,
  ...
}:

let
  neovim-config = inputs.nvim.packages.${system};
  neovim = neovim-config.neovim-with-plugins;
in

{
  home = {
    packages = [
      neovim
    ];

    sessionVariables.EDITOR = "${neovim}/bin/nvim";
  };

  xdg.configFile."nvim" = {
    enable = true;
    source = neovim-config.config-dir;
  };
}
