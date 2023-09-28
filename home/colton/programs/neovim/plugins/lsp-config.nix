{ inputs, pkgs, ... }:

{
  type = "lua";
  plugin = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "nvim-lspconfig";
    src = "${inputs.nvim-lspconfig}";
  };

  config = ''
    local lsp = require("lspconfig")

    vim.g.lsp_on_attach = function(client, buffer)
      local which_key = require("which-key")

      which_key.register({
        g = {
          name = "Go",
          ["."] = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to definition" },
          d = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to declaration" },
          D = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Go to type definition" },
          h = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover" },
          i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to implementation" },
          r = { "<cmd>lua vim.lsp.buf.references()<cr>", "Go to references" },
          s = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature help" },
          n = { "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", "Go to next diagnostic" },
          p = { "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", "Go to previous diagnostic" },
        }
      }, {
        buffer = buffer,
        mode = "n",
        noremap = true,
        silent = true,
      })

      which_key.register({
        ["<leader>"] = {
          c = {
            name = "Code",
            a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code action" },
            f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format" },
            r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
          },
        },
      }, {
        buffer = buffer,
        mode = "n",
        noremap = true,
        prefix = "<leader>",
        silent = true,
      })
    end

    lsp.tsserver.setup({
      cmd = { "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio" },
    })
  '';
}

