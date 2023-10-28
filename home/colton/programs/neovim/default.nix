{
  inputs,
  pkgs,
  system,
  ...
}:

{
  programs.neovim = {
    enable = true;

    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      bufferline-nvim
      cmp-nvim-lsp
      cmp-nvim-lsp-document-symbol
      cmp-nvim-lsp-signature-help
      cmp-vsnip
      comment-nvim
      copilot-vim
      neoscroll-nvim
      neo-tree-nvim
      noice-nvim
      nui-nvim
      nvim-treesitter.withAllGrammars
      nvim-cmp
      nvim-lspconfig
      plenary-nvim
      rust-tools-nvim
      telescope-nvim
      vim-vsnip
      which-key-nvim
    ];

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
