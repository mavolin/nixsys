{ base, ... }:
{
  virtualisation.libvirtd = {
    enable = true;
  };
  users.extraGroups.libvirtd.members = [ base.username ];
}
