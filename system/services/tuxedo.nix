{
  hardware.tuxedo-keyboard = {
    enable = true;
  };
  boot.kernelParams = [
    "tuxedo_keyboard.mode=0"
    "tuxedo_keyboard.color_left=0x000000"
    "tuxedo_keyboard.color_center=0x000000"
    "tuxedo_keyboard.color_right=0x000000"
  ];

  hardware.tuxedo-rs = {
    enable = true;
    tailor-gui = {
      enable = true;
    };
  };

  environment.etc."tailord/profiles/default.json".text = builtins.toJSON {
    fans = ["silent"];
    leds = [
      {
        device_name = "platform:tuxedo_keyboard";
        function = "kbd_backlight";
        profile = "none";
      }
    ];
    performance_profile = "entertainment";
  };
  environment.etc."tailord/profiles/keyboard_lighting.json".text = builtins.toJSON {
    fans = ["silent"];
    leds = [
      {
        device_name = "platform:tuxedo_keyboard";
        function = "kbd_backlight";
        profile = "dim";
      }
    ];
    performance_profile = ["entertainment"];
  };
  environment.etc."tailord/profiles/power_saving.json".text = builtins.toJSON {
    fans = ["silent"];
    leds = [
      {
        device_name = "platform:tuxedo_keyboard";
        function = "kbd_backlight";
        profile = "none";
      }
    ];
    performance_profile = ["power_saving"];
  };
  #
  environment.etc."tailord/keyboard/none.json".text = builtins.toJSON {
    Single = {
      r = 0;
      g = 0;
      b = 0;
    };
  };
  environment.etc."tailord/keyboard/dim.json".text = builtins.toJSON {
    Single = {
      r = 14;
      g = 14;
      b = 14;
    };
  };

  environment.etc."tailord/fan/silent.json".text = builtins.toJSON [
    {
      temp = 50;
      fan = 0;
    }
    {
      temp = 70;
      fan = 40;
    }
    {
      temp = 75;
      fan = 50;
    }
    {
      temp = 80;
      fan = 85;
    }
    {
      temp = 90;
      fan = 100;
    }
  ];
}
