{ inputs, ... }:

{
  plugin = {
    name = "which-key.nvim";
    src = inputs.which-key-nvim;
  };

  config = ''
    require("which-key").setup()
  '';
}

