{
  base,
  pkgs,
  derivations,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    openconnect
  ];
  environment.etc."resolv.unbound.conf".text = ''
    nameserver 127.0.0.1
    nameserver 1.1.1.1
    nameserver 9.9.9.9
    options edns0
  '';
  networking = {
    hostName = base.hostname;
    hostFiles = [
      "${derivations.adBlockList}/hosts"
    ];
    hosts = {
      "172.0.0.1" = [
        "a.local"
        "b.local"
        "c.local"
      ];
    };
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openconnect
        networkmanager-openvpn
        networkmanager-vpnc
      ];
    };

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
        {
          # Dev 8080
          from = 8080;
          to = 8085;
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

  services.unbound = {
    enable = true;
    settings = {
      server = {
        root-hints = "${pkgs.dns-root-data}/root.hints";
      };
      forward-zone = [
        {
          name = ".";
          forward-tls-upstream = true;
          forward-first = false;
          forward-addr = [
            "194.242.2.2@853"
            "9.9.9.9@853"
          ];
        }
      ];
    };
  };
}
