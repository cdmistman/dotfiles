args @ { lib, pkgs, ... }:
{
  programs.neovim.plugins =
    builtins.map
      (p: let
        imported = import p args;
      in imported // {
        type = if imported ? type then imported.type else "lua";
        plugin =
          if lib.isDerivation imported.plugin then
            imported.plugin
          else
            pkgs.vimUtils.buildVimPluginFrom2Nix imported.plugin;
      })
      [
        ./auto-save.nix
        ./cmp.nix
        ./comment.nix
        ./lsp-config.nix
        ./nvim-tree.nix
        ./rust-tools.nix
        ./telescope.nix
        ./treesitter-context.nix
        ./twilight.nix
        ./which-key.nix
      ];
}

