{base, ...}: {
  users.users.${base.username} = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
  };
}
