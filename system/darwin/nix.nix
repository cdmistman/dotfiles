{
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = "nix-command flakes";
    sandbox = true;
    trusted-users = ["root" "colton"];
  };
}
