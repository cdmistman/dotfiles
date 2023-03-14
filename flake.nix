{
	description = "My (cdmistman/colton) Nix config";

	inputs = {
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
			url = "github:cdmistman/mkAlias";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs @ {
		flake-utils,
		home-manager,
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
	};
}
