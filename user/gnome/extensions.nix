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
    tiling-assistant
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
        "tiling-assistant@leleat-on-github"
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
  };
}
