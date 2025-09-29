{ pkgs, ... }:
{
  home.packages = with pkgs.gnomeExtensions; [
    backslide
    battery-health-charging
    blur-my-shell
    caffeine
    force-quit
    gnome-40-ui-improvements
    # gnordvpn-local
    gsconnect
    pano
    smile-complementary-extension
    tiling-assistant
    vitals
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;

      enabled-extensions = [
        "backslide@codeisland.org"
        "Battery-Health-Charging@maniacx.github.com"
        "blur-my-shell@aunetx"
        "caffeine@patapon.info"
        "fq@megh"
        "gnome-ui-tune@itstime.tech"
        # "gnordvpn-local@isopolito"
        "gsconnect@andyholmes.github.io"
        "pano@elhan.io"
        "smile-extension@mijorus.it"
        "tiling-assistant@leleat-on-github"
        "Vitals@CoreCoding.com"
      ];
    };

    "org/gnome/shell/extensions/blur-my-shell" = {
      hacks-level = 3;
      sigma = 30;
      brightness = 0.50;
    };
    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      blur = false;
    };

    "org/gnome/shell/extensions/pano" = {
      global-shortcut = [ "<Super>v" ];
      history-length = 25;
      keep-search-entry = false;
      link-previews = true;
      open-links-in-browser = true;
      paste-on-select = true;
      play-audio-on-copy = false;
      send-notification-on-copy = false;
      show-indicator = false;
      watch-exclusion-list = true;
      exclusion-list = [ "1Password" ];

      window-height = 280;
    };
    "org/gnome/shell/extensions/pano/text-item" = {
      body-bg-color = "rgba(181,181,181,0.7)";
      body-font-family = "Cantarell";
      body-font-size = 14;
    };

    "org/gnome/shell/extensions/vitals" = {
      icon-style = 1;
      position-in-panel = 0;
      hot-sensors = [
        "_system_load_1m_"
        "__temperature_avg__"
        "_processor_usage_"
        "_memory_usage_"
        "__network-tx_max__"
        "__network-rx_max__"
        "_network_public_ip_"
      ];
    };
  };
}
