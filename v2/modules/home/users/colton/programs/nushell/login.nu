# let-env NIX_PROFILES = $"/nix/var/nix/profiles/default ($env.HOME)/.nix-profile"
let-env NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt"

# let-env PATH = ($env.PATH | split row (char esep) | prepend [
# 	$"($env.HOME)/.nix-profile/bin"
# 	"/nix/var/nix/profiles/default/bin"
# ])
