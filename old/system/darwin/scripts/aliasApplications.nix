{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}: let
  apps = config.system.build.applications;

  mkalias = inputs.mkAlias.outputs.apps.${system}.default.program;
in {
  system.activationScripts.applications.text = lib.mkForce ''
    echo "Linking Nix applications..."

    # only link system-wide applications
    app_path="/Applications/Nix Apps"
    tmp_path=$(mktemp -d "nix-apps.XXXXXX") || exit 1

    if [[ -d "$app_path" ]]; then
    	$DRY_RUN_CMD rm -rf "$app_path"
    fi

    ${pkgs.fd}/bin/fd \
    	-t l -d 1 . ${apps}/Applications \
    	-x $DRY_RUN_CMD ${mkalias} -L {} "$tmp_path/{/}"

    $DRY_RUN_CMD mv "$tmp_path" "$app_path"
  '';
}
