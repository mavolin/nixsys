{ ... }:
{
  powerManagement.enable = true;
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;
  services.thermald.enable = true;
}
