{
  mistman = {
    owned.enable = true;
    server.enable = true;
  };

  users = {
    createdUsers = [ "colton" ];
    knownUsers = [ "admin" "colton" ];

    users = {
      admin.uid = 501;
      colton.uid = 502;
    };
  };
}

