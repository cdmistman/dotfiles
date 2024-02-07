{ inputs, ... }: {
  imports = [
    inputs.nix-index-db.hmModules.nix-index

    ./editorconfig.nix
    ./home
    ./nix.nix

    ./programs/alacritty.nix
    ./programs/bash.nix
    ./programs/bat.nix
    ./programs/bottom.nix
    ./programs/direnv.nix
    ./programs/gh.nix
    ./programs/git.nix
    ./programs/helix.nix
    ./programs/jujutsu.nix
    ./programs/kitty
    ./programs/lsd.nix
    ./programs/neovim.nix
    ./programs/nix-index.nix
    ./programs/nushell
    ./programs/skim.nix
    ./programs/starship.nix
    ./programs/tealdeer.nix
    ./programs/vscode.nix
    ./programs/zellij
    ./programs/zoxide.nix
    ./programs/zsh.nix
  ];
}
