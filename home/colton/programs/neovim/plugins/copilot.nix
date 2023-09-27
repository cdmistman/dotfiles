{ inputs, pkgs, ... }:

{
  type = "lua";
  plugin = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "copilot-lua";
    src = inputs.copilot-lua;
  };
  config = ''
    require("copilot").setup({})

    vim.api.nvim_create_autocmd({"InsertEnter"}, {
      command = "silent! Copilot"
    })
  '';
}

