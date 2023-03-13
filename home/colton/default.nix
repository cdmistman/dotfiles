{
	imports ? [],
	inputs,
	system,
	...
}:

{
	imports = imports ++ [
		./editorconfig.nix
		./home.nix

		./programs/bash.nix
		./programs/bat.nix
		./programs/bottom.nix
		./programs/direnv.nix
		./programs/gh.nix
		./programs/git.nix
		./programs/helix.nix
		./programs/lsd.nix
		./programs/neovim.nix
		./programs/nix-index.nix
		./programs/skim.nix
		./programs/starship.nix
		./programs/tealdeer.nix
		./programs/zellij.nix
		./programs/zoxide.nix
		./programs/zsh.nix

		./scripts/aliasApplications.nix
	];
}