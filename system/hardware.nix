{ ... }:
{
  hardware.enableRedistributableFirmware = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.tuxedo-drivers = {
    enable = true;
  };
  boot.kernelParams = [
    "tuxedo_keyboard.mode=0"
  ];

  hardware.bluetooth = {
    powerOnBoot = false;
  };
}
