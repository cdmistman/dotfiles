args @ { pkgs, ... }:
{
  programs.neovim.plugins =
    builtins.map
      (p: import p args)
      [
        ./auto-save.nix
        ./copilot.nix
        ./lsp-config.nix
        ./nvim-tree.nix
        ./rust-tools.nix
        ./treesitter-context.nix
        ./which-key.nix
      ];
}

