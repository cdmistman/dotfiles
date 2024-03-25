{
  config,
  lib,
  ...
}:
lib.mkIf (config.mistman.profile.enable) {
  programs.direnv = {
    enableBashIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;

    nix-direnv.enable = true;

    config = {
      global = {
        warn_timeout = "1m";
      };

      whitelist.prefix = [
        "/Users/colton/github.com/cdmistman"
        "/home/colton/github.com/cdmistman"
      ];
    };
  };
}
