{
  base,
  pkgs,
  ...
}: {
  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [xterm];

    displayManager = {
      gdm = {
        enable = true;
        # spotify has some weird bugs
        wayland = false;
      };
    };
    desktopManager.gnome = {
      enable = true;
    };
  };
  services.displayManager.autoLogin = {
    enable = base.autoLogin;
    user = base.username;
  };
  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

  services.libinput = {
    enable = true;
    mouse = {
      accelProfile = "flat";
      naturalScrolling = true;
    };
  };

  # workaround for autologin
  # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  environment.gnome.excludePackages = with pkgs.gnome; [
    pkgs.gnome-tour
    pkgs.gnome-console
    pkgs.gnome-photos
    gnome-contacts
    gnome-disk-utility
    epiphany
    totem
    gnome-weather
  ];
  #environment.sessionVariables.NIXOS_OZONE_WL = "1"; # enable wayland support in chromium apps
}
