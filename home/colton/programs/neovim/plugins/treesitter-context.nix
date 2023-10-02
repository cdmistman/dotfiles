{ inputs, ... }:

{
  plugin = {
    name = "nvim-treesitter-context";
    src = inputs.nvim-treesitter-context;
  };

  config = ''
    require('treesitter-context').setup()
  '';
}

