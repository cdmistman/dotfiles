{ inputs, ... }:

{
  type = "lua";
  plugin = {
    name = "twilight-nvim";
    src = inputs.twilight-nvim;
  };

  config = ''
    require('twilight').setup()

    vim.api.nvim_create_autocmd({"UIEnter"}, {
      command = "TwilightEnable",
    })
  '';
}


