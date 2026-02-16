{ pkgs, lib, ... }:
{
  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    loader = {
      systemd-boot = {
        # Lanzaboote currently replaces the systemd-boot module.
        # This setting is usually set to true in configuration.nix
        # generated at installation time. So we force it to false
        # for now.
        enable = lib.mkForce false;
        editor = false;
        configurationLimit = 25;
      };
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };

    kernelParams = [ "acpi.ec_no_wakeup=1" ];

    initrd.luks.devices."crypt-nixos" = {
      allowDiscards = true;
      bypassWorkqueues = true;
    };
  };
  fileSystems."/boot".options = [ "umask=0077" ];

  environment.systemPackages = with pkgs; [ sbctl ];
}
