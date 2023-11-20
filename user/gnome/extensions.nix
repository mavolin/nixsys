{pkgs, ...}: {
  home.packages = with pkgs.gnomeExtensions; [
    backslide
    caffeine
    force-quit
    gnome-40-ui-improvements
    # gnordvpn-local
    gsconnect
    lock-keys
    pano
    tiling-assistant
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;

      enabled-extensions = [
        "backslide@codeisland.org"
        "caffeine@patapon.info"
        "fq@megh"
        "gnome-ui-tune@itstime.tech"
        # "gnordvpn-local@isopolito"
        "gsconnect@andyholmes.github.io"
        "lockkeys@vaina.lt"
        "pano@elhan.io"
        "tiling-assistant@leleat-on-github"
      ];
    };

    "org/gnome/shell/extensions/pano" = {
      global-shortcut = ["<Super>v"];
      history-length = 10;
      keep-search-entry = false;
      link-previews = true;
      open-links-in-browser = true;
      paste-on-select = true;
      play-audio-on-copy = false;
      send-notification-on-copy = false;
      show-indicator = false;
      watch-exclusion-list = true;
      exclusion-list = ["1Password"];

      window-height = 280;
    };
    "org/gnome/shell/extensions/pano/text-item" = {
      body-bg-color = "rgba(181,181,181,0.7)";
      body-font-family = "Cantarell";
      body-font-size = 14;
    };
  };
}
