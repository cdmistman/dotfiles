{pkgs, ...}: {
  users.users.admin = {
    createHome = true;

    description = "Admin user";

    home = "/Users/admin";

    isHidden = true;
  };
}
