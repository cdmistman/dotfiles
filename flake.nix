{
	description = "My (cdmistman/colton) Nix config";

	inputs = {
		# TODO: use nixos/nixpkgs-unstable, have to wait for starship 1.15.0
		# to release, likely in June
		# nixpkgs.url = "github:cdmistman/nixpkgs";
		nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

		darwin = {
			url = "github:LnL7/nix-darwin";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		mkAlias = {
			url = "github:reckenrode/mkAlias";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs @ {
		home-manager,
		nixpkgs,
		...
	}: {
		darwinConfigurations = {
			donn-mbp = import ./system/darwin {
				inherit inputs;

				system = "aarch64-darwin";

				modules = [
					{
						networking.computerName = "Colton’s MacBook Pro";
						networking.hostName = "donn-mbp";
					}
				];
			};

			donn-replit-mbp = import ./system/darwin {
				inherit inputs;

				system = "aarch64-darwin";

				modules = [
					{
						networking.computerName = "Colton’s Replit MacBook Pro";
						networking.hostName = "donn-replit-mbp";
					}
				];
			};
		};

		homeConfigurations.replit-devvm =
			let
				system = "x86_64-linux";
				pkgs = nixpkgs.legacyPackages.${system};
			in home-manager.lib.homeManagerConfiguration {
				inherit pkgs;

				extraSpecialArgs = {
					inherit inputs system;

					enableGUI = false;
				};

				modules = [
					(import ./home/colton)
					{
						home.homeDirectory = "/home/colton";
					}
				];
			};
	};
}
