{pkgs, ...}: {
  services.printing = {
    enable = true;

    drivers = with pkgs; [epson-escpr];

    # The printers at Uni Hamburg on the compsci campus
    browsedConf = ''
      BrowsePoll linuxprint.informatik.uni-hamburg.de:631
    '';
  };
}
