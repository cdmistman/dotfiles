{ inputs, pkgs, system, ... }:

let
  rust-analyzer = inputs.fenix.packages.${system}.rust-analyzer;
in

{
  type = "lua";
  plugin = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "rust-tools-nvim";
    src = "${inputs.rust-tools-nvim}";
  };
  config = ''
    require('rust-tools').setup({
      server = {
        cmd = { "${rust-analyzer}/bin/rust-analyzer" },
        on_attach = vim.g.lsp_on_attach,
      },
    })
  '';
}

