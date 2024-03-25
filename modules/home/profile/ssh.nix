{
  config,
  lib,
  ...
}:
lib.mkIf (config.mistman.profile.enable) {
  programs.ssh = {
    includes = ["config.d/*"];

    matchBlocks.github = {
      hostname = "github.com";
      extraOptions.Tag = "git-remote";
    };

    matchBlocks.git-remote = {
      match = "tagged git-remote";
      port = 22;
      user = "git";
    };

    matchBlocks.work = {
      match = "tagged work";
      extraOptions.AddKeysToAgent = "yes";
      extraOptions.ControlPersist = "10m";
    };

    compression = true;
    controlPath = "~/.ssh/multiplexing/%r@%h:%p";
    hashKnownHosts = true;
  };
}
