{ ... }:
{
  boot = {
    loader.systemd-boot = {
      enable = true;
      editor = false;
      configurationLimit = 25;
    };
    loader.timeout = 0;
    loader.efi.canTouchEfiVariables = true;

    kernelParams = [ "acpi.ec_no_wakeup=1" ];

    initrd.luks.devices."crypt-nixos" = {
      allowDiscards = true;
      bypassWorkqueues = true;
    };
  };
}
