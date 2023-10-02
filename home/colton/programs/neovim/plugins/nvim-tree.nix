{ inputs, ... }:

{
  plugin = {
    name = "neo-tree.nvim";
    src = inputs.neo-tree-nvim;
  };

  config = ''
    require('neo-tree').setup({
      sort_case_insensitive = true,
      default_component_configs = {
        indent = {
          indent_size = 1
        },
      },
    })
  '';
}

