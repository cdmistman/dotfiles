{
  mistman.profile.enable = true;

  services.ollama.enable = true;

  users.users.admin = {
    createHome = true;
  };

  users.users.colton = {
    createHome = false;
  };
}
