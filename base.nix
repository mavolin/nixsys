rec {
  system = "x86_64-linux";
  hostname = "mavolin-laptop";
  username = "mavolin";
  autoLogin = true;

  timeZone = "Europe/Berlin";
  locale = {
    default = "en_GB.UTF-8";
    collate = "de_DE.UTF-8";
    measurement = "de_DE.UTF-8";
    paper = "de_DE.UTF-8";
    telephone = "de_DE.UTF-8";
  };

  backup = {
    # In order for backups to work, a restic rest server must be running
    # on the host specified below.
    # Additionally, you need to place a file named passwd with the encryption
    # password and a file named rest_passwd with the rest server password in
    # secrets/restic.
    enabled = true;
    server = "rocketman.backup.mavolin.co";
    user = hostname;
    ntfy = {
      # needs a secrets/restic/ntfy_token
      enabled = true;
      url = "https://ntfy.mavolin.co";
      topic = "backup";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  stateVersion = "23.05"; # Did you read the comment?
}
