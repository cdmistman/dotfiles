{ pkgs, ... }:

{
  type = "lua";
  plugin = pkgs.vimPlugins.nvim-treesitter-context;
  config = ''
    require('treesitter-context').setup()
  '';
}

