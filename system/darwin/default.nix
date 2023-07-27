{
	modules ? [],
	inputs,
	system,
}:

inputs.darwin.lib.darwinSystem {
	inherit system;

	pkgs = inputs.nixpkgs.legacyPackages.${system};

	specialArgs = {
		inherit inputs system;
	};

	modules = modules ++ [
		../../cachix

		./environment.nix
		./fonts.nix
		./nix.nix
		./system.nix

		./scripts/aliasApplications.nix

		./users/colton.nix
		./users/admin.nix

		inputs.home-manager.darwinModules.home-manager
		{
			home-manager.extraSpecialArgs = {
				inherit inputs system;

				enableGUI = true;
			};

			home-manager.sharedModules = [
				../../home/_common
			];

			home-manager.users.colton = import ../../home/colton;
		}

		{
			programs.bash.enable = true;
			programs.zsh.enable = true;

			programs.vim = {
				enable = true;
				enableSensible = true;
			};

			security.pam.enableSudoTouchIdAuth = true;

			services.cachix-agent.enable = true;
			services.nix-daemon.enable = true;
		}
	];
}
