{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  nixpkgs.overlays = [
    inputs.emacs-overlay.overlays.emacs
    inputs.emacs-overlay.overlays.package
  ];

  home.file."bin/emacs" =
    lib.mkIf
      pkgs.stdenv.isDarwin {
        text = "${config.programs.emacs.finalPackage}/Applications/Emacs.app/Contents/MacOS/Emacs";
        executable = true;
      };

  services.emacs.enable = pkgs.stdenv.isLinux;

  programs.emacs = {
    enable = true;

    package = pkgs.emacs29-pgtk.overrideAttrs (old: {
      patches =
        (old.patches or [ ])
        ++ [
          # Fix OS window role (needed for window managers like yabai)
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
            hash = "sha256-+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
          })
          # Use poll instead of select to get file descriptors
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-29/poll.patch";
            hash = "sha256-jN9MlD8/ZrnLuP2/HUXXEVVd6A+aRZNYFdZF8ReJGfY=";
          })
          # Enable rounded window with no decoration
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-29/round-undecorated-frame.patch";
            hash = "sha256-uYIxNTyfbprx5mCqMNFVrBcLeo+8e21qmBE3lpcnd+4=";
          })
          # Make Emacs aware of OS-level light/dark mode
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/system-appearance.patch";
            hash = "sha256-oM6fXdXCWVcBnNrzXmF0ZMdp8j0pzkLE66WteeCutv8=";
          })
        ];
    });
  };

  home.file.".doom.d" = {
    recursive = true;
    source = ./.;
  };

  # home.file.".emacs.d" = {
  #   source = "${inputs.doomemacs}";
  #   recursive = true;
  # };

  # xdg.configFile."emacs" = {
  #   source = ./.;
  #   recursive = true;
  # };
}
