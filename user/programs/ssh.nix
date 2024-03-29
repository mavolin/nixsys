{base, ...}: {
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host backup
        Hostname ${base.backup.host}
        Port ${toString base.backup.port}
        User borg
        IdentityFile ${base.backup.identityFile}
        IdentityAgent /
        ServerAliveInterval 60
        ServerAliveCountMax 240

      Host *
       IdentityAgent ~/.1password/agent.sock
    '';
  };
}
