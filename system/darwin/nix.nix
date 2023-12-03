{
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = "nix-command flakes";
    sandbox = false;
    trusted-users = ["root" "colton"];
  };
}
