{ inputs, system, ... }:

let
  rust-analyzer = inputs.fenix.packages.${system}.rust-analyzer;
in

{
  plugin = {
    name = "rust-tools.nvim";
    src = inputs.rust-tools-nvim;
  };

  config = ''
    require('rust-tools').setup({
      server = {
        capabilities = vim.g.lsp_capabilities,
        cmd = { "${rust-analyzer}/bin/rust-analyzer" },
        on_attach = vim.g.lsp_on_attach,
      },
    })
  '';
}

