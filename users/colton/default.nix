{
	pkgs,
	...
}: {
	home-manager.users.colton = {
		imports = [
			./modules/editorconfig.nix

			./programs/bash.nix
			./programs/bat.nix
			./programs/bottom.nix
			./programs/direnv.nix
			./programs/gh.nix
			./programs/git.nix
			./programs/helix.nix
			./programs/lsd.nix
			./programs/neovim.nix
			./programs/skim.nix
			./programs/starship.nix
			./programs/tealdeer.nix
			./programs/vscode.nix
			./programs/zellij.nix
			./programs/zoxide.nix
			./programs/zsh.nix
		];

		home = {
			enableNixpkgsReleaseCheck = true;
			stateVersion = "22.11";

			packages = with pkgs; [
				du-dust
				procs
				ripgrep
				sd
				tokei
			];

			sessionPath = [
				"$HOME/bin"
			];

			sessionVariables = {
				MANPAGER = "sh -c 'col -bx | bat -l man -p'";

				PAGER = "bat";
			};

			shellAliases = {
				k = "clear";
				kn = "clear && printf '\\e[3J'";

				ls = "lsd -A --group-directories-first --hyperlink auto";
				l = "ls";
				la = "ls -a";
				ll = "ls -l";

				tree = "lsd -L --tree";
			};
		};

		programs.command-not-found.enable = true;
	};
}
