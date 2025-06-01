{ base, ... }:
{
  networking = {
    hostName = base.hostname;
    extraHosts = ''
      127.0.0.1 a.local
      127.0.0.1 b.local
      127.0.0.1 c.local
    '';
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPortRanges = [
        {
          # GSConnect
          from = 1714;
          to = 1764;
        }
        {
          # AusweisApp
          from = 24727;
          to = 24727;
        }
      ];
      allowedUDPPortRanges = [
        {
          # GSConnect
          from = 1714;
          to = 1764;
        }
        {
          # AusweisApp
          from = 24727;
          to = 24727;
        }
      ];

      # wireguard trips rpfilter up
      extraCommands = ''
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
      '';
      extraStopCommands = ''
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
      '';
    };
  };
}
