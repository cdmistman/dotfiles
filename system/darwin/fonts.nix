{pkgs, ...}: {
  fonts = {
    fontDir.enable = true;

    fonts = [
      (pkgs.nerdfonts.override {
        fonts = [
          "FiraCode"
          "FiraMono"
          "Hack"
        ];
      })
    ];
  };
}
