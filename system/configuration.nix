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

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      # there isn't even a fix upstream yet,
      # since i need this for work, imma just ignore
      "figma-linux-0.10.0"
    ];
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

    firewall = {
      enable = true;
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
  };

  powerManagement = {
    enable = true;
    cpufreq.max = 3000000;
  };
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;
  services.thermald.enable = true;

  system.stateVersion = base.stateVersion;
}
