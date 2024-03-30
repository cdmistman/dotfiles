{ config, inputs, lib, pkgs, ... }: lib.mkIf config.mistman.profile.enable {
  vanillinvim = {
    enable = true;
    tools = [];
    fallback-tools = [
      pkgs.nodejs_20
    ];

    plugins = {
      inherit
        (inputs)
        cmp-buffer
        cmp-nvim-lsp
        cmp-nvim-lsp-document-symbol
        cmp-nvim-lsp-signature-help
        cmp-vsnip
        copilot-cmp
        nvim-cmp
        nvim-lspconfig
        nvim-notify
        nvim-treesitter
        nvim-treesitter-context
        nvim-web-devicons
        vim-vsnip
        ;

      "aerial.nvim" = inputs.aerial-nvim;
      "bufferline.nvim" = inputs.bufferline-nvim;
      "comment.nvim" = inputs.comment-nvim;
      "copilot.lua" = inputs.copilot-lua;
      "direnv.vim" = inputs.direnv-vim;
      "flash.nvim" = inputs.flash-nvim;
      "hydra.nvim" = inputs.hydra-nvim;
      "neoscroll.nvim" = inputs.neoscroll-nvim;
      "neo-tree.nvim" = inputs.neo-tree-nvim;
      "noice.nvim" = inputs.noice-nvim;
      "nui.nvim" = inputs.nui-nvim;
      "peek.nvim" = inputs.peek-nvim;
      "persistence.nvim" = inputs.persistence-nvim;
      "plenary.nvim" = inputs.plenary-nvim;
      "rustaceanvim" = inputs.rustaceanvim;
      "startup.nvim" = inputs.startup-nvim;
      "substitute.nvim" = inputs.substitute-nvim;
      "telescope.nvim" = inputs.telescope-nvim;
      "todo-comments.nvim" = inputs.todo-comments-nvim;
      "tokyonight.nvim" = inputs.tokyonight;
      "which-key.nvim" = inputs.which-key-nvim;
      "yanky.nvim" = inputs.yanky-nvim;
    };
  };

  xdg.configFile.nvim = {
    source = builtins.filterSource (path: _: ! lib.hasSuffix ".nix" path) ./.;
    recursive = true;
  };
}
