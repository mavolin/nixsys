{
  base,
  pkgs,
  ...
}: {
  programs.borgmatic = {
    enable = true;
    backups = {
      home = {
        location = {
          sourceDirectories = [
            "/home/${base.username}"
          ];
          repositories = [
            {
              label = base.backup.host;
              # c.f. ssh.nix
              path = "ssh://backup/./${base.backup.repository}";
            }
          ];
          extraConfig = {
            exclude_patterns = [
              "home/${base.username}/.1password"
              "home/${base.username}/.cache"
              "home/${base.username}/.compose-cache"
              "home/${base.username}/.java"
              "home/${base.username}/.m2"
              "home/${base.username}/.mozilla"
              "home/${base.username}/.npm"
              "home/${base.username}/.tldrc"
            ];
          };
        };
        retention = {
          keepHourly = 18;
          keepDaily = 7;
          keepWeekly = 4;
          keepMonthly = 3;
        };

        # there's no global extraConfig, but this is just as good
        storage.extraConfig =
          (
            if base.backup.encrypt
            then {
              encryption_passphrase = builtins.readFile ./borgmatic_enc_passphrase;
            }
            else {}
          )
          // (
            if base.backup.ntfy.user == null
            then {}
            else {
              ntfy = {
                topic = base.backup.ntfy.topic;
                server = base.backup.ntfy.server;
                username = base.backup.ntfy.user;
                password = builtins.readFile ./borgmatic_ntfy_passwd;

                start = {
                  title = "${base.hostname}: Backup started";
                  message = "Started backup to ${base.backup.host}::${base.backup.repository}";
                  tags = "floppy_disk";
                  priority = "low";
                };
                finish = {
                  title = "${base.hostname}: Backup finished";
                  message = "Finished backup up to ${base.backup.host}::${base.backup.repository}";
                  tags = "white_check_mark";
                  priority = "low";
                };
                fail = {
                  title = "${base.hostname}: Backup failed";
                  message = "Failed backup up to ${base.backup.host}::${base.backup.repository}";
                  tags = "rotating_light";
                  priority = "high";
                };
                states = ["finish" "fail"];
              };
            }
          );
      };
    };
  };

  services.borgmatic = {
    enable = true;
    frequency = "00,04,12..21/3:00";
  };
}
