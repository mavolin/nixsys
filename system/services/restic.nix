{base, ...}: let
  restPasswd = builtins.readFile ../../secrets/restic_rest_passwd;
in
  {
    services.restic.backups.${base.backup.server} = {
      repository = "rest:https://${base.backup.user}:${restPasswd}@${base.backup.server}/${base.hostname}";
      passwordFile = builtins.toFile "restic_passwd" (builtins.readFile ../../secrets/restic_passwd);
      paths = [
        "/home/${base.username}"
      ];
      inhibitsSleep = true;
      exclude = [
        "home/${base.username}/.1password"
        "home/${base.username}/.cache"
        "home/${base.username}/.compose-cache"
        "home/${base.username}/.java"
        "home/${base.username}/.local/share/Steam/steamapps"
        "home/${base.username}/.local/share/Steam/ubuntu*"
        "home/${base.username}/.m2"
        "home/${base.username}/.mozilla"
        "home/${base.username}/.npm"
        "home/${base.username}/.tldrc"
      ];
      pruneOpts = [
        "--keep-hourly 24"
        "--keep-daily 28"
        "--keep-weekly 8"
        "--keep-monthly 6"
      ];
      timerConfig = {
        OnCalendar = "00,04,12..21/3:00";
        Persistent = true;
      };
    };
  }
  // (
    if base.backup.ntfy.enabled
    then {
      systemd.services."restic-backups-${base.backup.server}" = {
        unitConfig.OnFailure = ["ntfy-failure@restic-backups-${base.backup.server}"];
      };
      systemd.services."ntfy-failure@restic-backups-${base.backup.server}" = {
        enable = true;
        description = "Failure notification for %i";
        script = ''
          ntfy publish \
            --title "Backup failed" \
            --tags warning \
            --priority high \
            --token ${builtins.readFile ../../secrets/restic_ntfy_token} \
            ${base.backup.ntfy.url}/${base.backup.ntfy.topic} "$(journalctl -u "$unit" -o cat -n 15)"
        '';
      };
    }
    else {}
  )
