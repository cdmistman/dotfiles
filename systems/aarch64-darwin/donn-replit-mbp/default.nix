{pkgs, ...}: {
  mistman.profile.enable = true;

  users.users.admin = {
    createHome = true;
  };

  users.users.colton = {
    createHome = false;
  };
}
