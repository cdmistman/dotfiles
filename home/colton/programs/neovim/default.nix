{
  pkgs,
  ...
}:

{
  imports = [
    ./plugins
  ];

  programs.neovim = {
    enable = true;

    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      cmp-nvim-lsp
      cmp-nvim-lsp-document-symbol
      cmp-nvim-lsp-signature-help
      cmp-vsnip

      copilot-vim
      nui-nvim
      nvim-treesitter.withAllGrammars

      plenary-nvim

      vim-vsnip
    ];

    withNodeJs = true;

    vimdiffAlias = true;

    extraLuaConfig = ''
      ${builtins.readFile ./init.lua}
    '';
  };
}
