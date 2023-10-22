{base, ...}: {
  services.cron = {
    enable = base.emptyDownloadsOnReboot;
    systemCronJobs = [
      "@reboot rm -rf '/home/${base.username}/Downloads/*"
    ];
  };
}
