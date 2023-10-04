{
  inputs,
  pkgs,
  ...
}:

{
  nixpkgs.overlays = [
    inputs.emacs-overlay.overlays.emacs
    inputs.emacs-overlay.overlays.package
  ];

  services.emacs.enable = pkgs.stdenv.isLinux;

  programs.emacs = {
    enable = true;

    package = pkgs.emacs29-nox;
  };

  xdg.configFile."emacs" = {
    source = ./.;
    recursive = true;
  };
}
