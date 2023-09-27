args @ { pkgs, ... }:
{
  programs.neovim.plugins =
    builtins.map
      (p: import p args)
      [
        ./auto-save.nix
        ./copilot.nix
        ./nvim-tree.nix
      ];
}

