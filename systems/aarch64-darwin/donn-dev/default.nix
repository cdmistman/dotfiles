{
  mistman = {
    owned.enable = true;
    server.enable = true;
  };

  users = {
    # NOTE: append-only
    knownUsers = [ "colton" ];

    users = {
      colton.uid = 601;
    };
  };
}

