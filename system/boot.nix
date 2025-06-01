{ pkgs, ... }:
{
  boot = {
    loader.systemd-boot = {
      enable = true;
      editor = false;
      configurationLimit = 25;
    };
    loader.timeout = 0;
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxPackages_latest;
  };
}
