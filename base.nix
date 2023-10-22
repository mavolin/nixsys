{
  system = "x86_64-linux";
  hostname = "mavolin-laptop";
  username = "mavolin";
  autoLogin = true;
  # whether to delete the contents of the Downloads folder every reboot
  emptyDownloadsOnReboot = true;

  timeZone = "Europe/Berlin";
  locale = {
    default = "en_GB.UTF-8";
    collate = "de_DE.UTF-8";
    measurement = "de_DE.UTF-8";
    paper = "de_DE.UTF-8";
    telephone = "de_DE.UTF-8";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  stateVersion = "23.05"; # Did you read the comment?
}
