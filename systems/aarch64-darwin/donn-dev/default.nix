{pkgs, ...}: {
  mistman = {
    profile.enable = true;
    owned.enable = true;
    server.enable = true;
  };

  users = {
    # NOTE: append-only
    knownGroups = ["colton" "commptonn"];
    groups.colton = {
      description = "colton";
      gid = 601;
      members = ["colton"];
    };

    groups.commptonn = {
      description = "commptonn";
      gid = 602;
      members = ["commptonn"];
    };

    knownUsers = ["colton" "commptonn"];
    users.admin = {
      createHome = false;
    };

    users.colton = {
      createHome = true;
    };

    users.commptonn = {
      createHome = true;
      description = "commptonn";
      gid = 20;
      home = "/Users/commptonn";

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIArYAmI4x/5cPMc1D3EkOMfDex9F8LOoe3Mnap04JZv4 root@ignite"
      ];

      shell = "${pkgs.zsh}/bin/zsh";
      uid = 602;
    };
  };
}
