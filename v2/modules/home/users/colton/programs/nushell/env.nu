# Default at https://github.com/nushell/nushell/blob/main/crates/nu-utils/src/sample_config/default_env.nu

let-env NIX_PREFIX = "/nix/var/nix"

let-env PATH = ($env.PATH | split row (char esep))
let-env PATH = (
	if ('NIX_PROFILES' in ($env).name) {
		$env.PATH
	} else {
		$env.PATH | prepend [
			$"($env.HOME)/.nix-profile/bin"
			"/nix/var/nix/profiles/default/bin"
		]
	}
)

let-env NIX_PROFILES = $"/nix/var/nix/profiles/default ($env.HOME)/.nix-profile"
