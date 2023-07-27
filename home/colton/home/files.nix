{
	ezshell = {
		target = "bin/ezshell";
		executable = true;

		text = ''
			#!/bin/sh

			if [ -z "$1" ]; then
				echo "Usage: ezshell <profile>"
				exit 1
			fi

			nix develop "github:cdmistman/nix-config#$1" -c "$SHELL"
		'';
	};
}
