{ inputs, ... }:

{
  plugin = {
    name = "auto-save.nvim";
    src = inputs.auto-save-nvim;
  };

  config = ''
    require("auto-save").setup()
  '';
}

