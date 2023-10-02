{ inputs, ... }:

{
  plugin = {
    name = "telescope.nvim";
    src = inputs.telescope-nvim;
  };

  config = ''
    require("telescope").setup()

    local which_key = require("which-key")

    which_key.register({
      f = {
        name = "File",
        f = { "<cmd>lua require('telescope.builtins').find_files()<cr>", "Find File" },
        g = { "<cmd>lua require('telescope.builtins').live_grep()<cr>", "Grep" },
        b = { "<cmd>lua require('telescope.builtins').buffers()<cr>", "Buffers" },
        h = { "<cmd>lua require('telescope.builtins').help_tags()<cr>", "Help" },
      },
    }, {
      mode = "n",
      prefix = "<leader>",
      silent = true,
    })
  '';
}

