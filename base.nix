rec {
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

  backup = {
    # In order for backups to work, a borg backup server must be running
    # on the host specified below.
    # Additionally, you must generate a ssh key pair, e.g. with ssh-keygen,
    # and add the public key to the authorized_keys file of the server.
    enabled = true;
    host = "backup.mavolin.co";
    port = 2222;
    # If the backups are to be encrypted, a passphrase must be provided
    # in 'user/programs/borgmatic_enc_passphrase'.
    # To disable encryption, set this to false.
    encrypt = true;
    # Name of the repository on the backup server.
    repository = "home";
    # This is the file that contains the private key used to authenticate
    # with the borg backup server.
    identityFile = "/home/${username}/.ssh/id_borg";
    ntfy = {
      # If set to null, no ntfy notifications will be sent.
      # Password will be read from 'user/programs/borgmatic_ntfy_passwd'.
      user = "${hostname}-borgmatic";
      server = "https://ntfy.mavolin.co";
      topic = "${hostname}-backup";
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
