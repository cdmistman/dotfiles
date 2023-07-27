{pkgs, ...}: {
  environment = {
    loginShell = "/bin/zsh";

    systemPackages = with pkgs; [
      cachix
    ];
  };
}
