{base, pkgs, ...}: let
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
    then let
      backup-unit = "restic-backups-${base.backup.server}";
      backup-service = "${backup-unit}.service";
    in {
      systemd.services.${backup-unit} = {
        unitConfig.OnFailure = ["ntfy-failure@${backup-service}"];
      };
      systemd.services."ntfy-failure@${backup-unit}" = {
        enable = true;
        description = "Failure notification for %i";
        script = ''
          ${pkgs.ntfy-sh}/bin/ntfy publish \
            --title "Backup failed" \
            --tags warning \
            --priority high \
            --token ${builtins.readFile ../../secrets/restic_ntfy_token} \
            ${base.backup.ntfy.url}/${base.backup.ntfy.topic} "$(journalctl -u ${backup-service} -o cat -I)"
        '';
      };
    }
    else {}
  )
