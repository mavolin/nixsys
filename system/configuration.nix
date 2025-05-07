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
    ./power_management.nix
    ./programs.nix
    ./services
    ./systemd.nix
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

  system.stateVersion = base.stateVersion;
}
