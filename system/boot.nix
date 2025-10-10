{
  pkgs,
  unstable-pkgs,
  ...
}:
{
  boot = {
    loader.systemd-boot = {
      enable = true;
      editor = false;
      configurationLimit = 25;
    };
    loader.timeout = 0;
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxPackages_latest.extend (
      final: prev: {
        tuxedo-drivers = (unstable-pkgs.linuxPackagesFor pkgs.linuxPackages_latest.kernel).tuxedo-drivers;
        yt6801 = (unstable-pkgs.linuxPackagesFor pkgs.linuxPackages_latest.kernel).yt6801;
      }
    ); # todo: remove when tuxedo-drivers >= 4.13.0 is available in stable channel
    kernelParams = [ "acpi.ec_no_wakeup=1" ];
  };
}
