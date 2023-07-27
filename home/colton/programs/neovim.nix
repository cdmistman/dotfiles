{pkgs, ...}: {
  programs.neovim = {
    enable = true;

    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars

      SchemaStore-nvim
      Shade-nvim
    ];

    vimAlias = true;
    vimdiffAlias = true;
  };
}
