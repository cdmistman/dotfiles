{ config, lib, ... }:

let
  cfg = config.mistman.users.colton;
in

{
  imports = [
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

  options.mistman.users.colton = {
    enable = lib.mkEnableOption "users.colton";
    gui = lib.mkEnableOption "users.colton.gui";
  };
}

