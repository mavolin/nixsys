{
  hardware.tuxedo-keyboard = {
    enable = true;
  };
  boot.kernelParams = [
    "tuxedo_keyboard.state=0"
    "tuxedo_keyboard.mode=0"
    "tuxedo_keyboard.color_left=0xffffff"
    "tuxedo_keyboard.color_center=0xffffff"
    "tuxedo_keyboard.color_right=0xffffff"
  ];

  hardware.tuxedo-control-center = {
    enable = true;
  };
}
