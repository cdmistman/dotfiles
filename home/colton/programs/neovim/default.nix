{
  inputs,
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
      editorconfig-nvim
      which-key-nvim

      nvim-treesitter.withAllGrammars
    ];

    withNodeJs = true;

    vimdiffAlias = true;

    extraLuaConfig = ''
      ${builtins.readFile ./init.lua}
    '';
  };
}
