{
  inputs,
  pkgs,
  system,
  ...
}:

let
  raw-plugins = with inputs; [
    { name = "auto-save.nvim"; src = auto-save-nvim; }
    { name = "bufferline.nvim"; src = bufferline-nvim; }
    { name = "comment.nvim"; src = comment-nvim; }
    { name = "neoscroll.nvim"; src = neoscroll-nvim; }
    { name = "nvim-cmp"; src = inputs.nvim-cmp; }
    { name = "nvim-lspconfig"; src = nvim-lspconfig; }
    { name = "neo-tree.nvim"; src = neo-tree-nvim; }
    { name = "noice.nvim"; src = noice-nvim; }
    { name = "nvim-treesitter-context"; src = nvim-treesitter-context; }
    { name = "rust-tools.nvim"; src = rust-tools-nvim; }
    { name = "telescope.nvim"; src = telescope-nvim; }
    { name = "which-key.nvim"; src = which-key-nvim; }
  ];

  plugins = builtins.map pkgs.vimUtils.buildVimPluginFrom2Nix raw-plugins;
in

{
  programs.neovim = {
    enable = true;

    defaultEditor = true;

    plugins = plugins ++ (with pkgs.vimPlugins; [
      cmp-nvim-lsp
      cmp-nvim-lsp-document-symbol
      cmp-nvim-lsp-signature-help
      cmp-vsnip

      copilot-vim
      nui-nvim
      nvim-treesitter.withAllGrammars

      plenary-nvim

      vim-vsnip
    ]);

    withNodeJs = true;

    vimdiffAlias = true;

    extraLuaConfig = ''
      ${builtins.readFile ./init.lua}
    '';

    extraPackages =
      let
        inherit (inputs.fenix.packages.${system}) rust-analyzer;

        inherit (pkgs) gopls nil;

        inherit (pkgs.nodePackages_latest) typescript-language-server;
      in [
        gopls
        nil
        rust-analyzer
        typescript-language-server
      ];
  };
}
