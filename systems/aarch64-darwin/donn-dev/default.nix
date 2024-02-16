{ pkgs, ... }: {
  mistman = {
    owned.enable = true;
    server.enable = true;
  };

  # NOTE: append-only
  users.knownGroups = [ "colton" "commptonn" ];
  users.knownUsers = [ "colton" "commptonn" ];

  users.groups.colton = {
    description  = "colton";
    gid = 601;
    members = [ "colton" ];
  };

  users.users.commptonn = {
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
}

