{
  inputs,
  system,
  ...
}: {
  programs.jujutsu = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    package = inputs.jujutsu.packages.${system}.jujutsu;

    settings = {
      user = {
        name = "Colton Donnelly";
        email = "colton@donn.io";
      };
    };
  };
}

