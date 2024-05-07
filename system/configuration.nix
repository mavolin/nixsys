{
  base,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ./boot.nix
    ./fonts.nix
    ./hardware-acceleration.nix
    ./i18n.nix
    ./networking.nix
    ./programs.nix
    ./services
    ./steam.nix
    ./users.nix
    ./xkb.nix
  ];

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  powerManagement = {
    enable = true;
    cpufreq.max = 3200000;
  };
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;
  services.thermald.enable = true;

  system.stateVersion = base.stateVersion;
}
