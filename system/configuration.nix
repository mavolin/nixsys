{
  base,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ./fonts.nix
    ./i18n.nix
    ./programs.nix
    ./services
    ./users.nix
    ./xkb.nix
  ];

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
  };

  # for some reason, this needs to stay together (or at the very
  # least in the same file). if permittedInsecurePackages is moved
  # to the location where it's used (tuxedo.nix), it, for reasons
  # beyond me, won't get applied.
  nixpkgs.config = {
    allowUnfree = true;
    # needed for tuxedo control center
    permittedInsecurePackages = ["openssl-1.1.1w" "nodejs-14.21.3" "electron-13.6.9"];
  };

  boot = {
    loader.systemd-boot = {
      enable = true;
      editor = false;
      configurationLimit = 25;
    };
    loader.timeout = 0;
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      # https://www.tuxedocomputers.com/en/Infos/Help-Support/Instructions/Fine-tuning-of-power-management-with-suspend-standby.tuxedo
      "mem_sleep_default=deep"
      # https://github.com/tuxedocomputers/tuxedo-tomte/blob/b1181c8ecae829b218e9a2e2a97d4f6e0baf5c99/src/tuxedo-tomte#L5459
      "i915.tuxedo_disable_psr2=1"
      "i915.enable_psr=1"
    ];
  };

  networking = {
    hostName = base.hostname;
    extraHosts = ''
      127.0.0.1 a.loc
      127.0.0.1 b.loc
      127.0.0.1 c.loc
    '';
    networkmanager.enable = true;
  };

  powerManagement.enable = true;
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;
  services.thermald.enable = true;

  system.stateVersion = base.stateVersion;
}
