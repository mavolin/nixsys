{ base, ... }:
{
  services.usbguard = {
    enable = true;
    presentControllerPolicy = "allow";
    IPCAllowedUsers = [ base.username ];
  };

  # Gnome integration configured in user/programs/usbguard.nix
}
