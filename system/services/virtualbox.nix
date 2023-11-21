{base, ...}: {
  virtualisation.virtualbox.host = {
    enable = true;
  };
  users.extraGroups.vboxusers.members = [base.username];
}
