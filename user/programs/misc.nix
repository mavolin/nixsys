{
  base,
  pkgs, unstable-pkgs,
  config,
  lib,
  ...
}: {
  ##################
  #### PROGRAMS ####
  ##################

  home.packages = with pkgs; [
    gnome.aisleriot
    any-nix-shell
    apostrophe
    blackbox-terminal
    gnome.gnome-chess
    ciano # converter
    contrast
    collision # hash checker
    gnome.dconf-editor
    ddrescue
    discord
    drawing
    drawio
    emote
    figma-linux
    figma-agent
    filezilla
    fortune # fortune cookie message cli
    unstable-pkgs.lorem
    geogebra6
    gimp
    gnumake
    go
    gotools
    gofumpt
    golangci-lint
    gparted
    gthumb
    impression
    inkscape
    pstoedit # dep of inkscape, for opening .eps
    jellyfin-media-player
    john
    killall
    libsForQt5.kdenlive
    less
    libreoffice-fresh
    gnome.gnome-mahjongg
    meld
    minder
    gnome.gnome-nettool
    # nordvpn # todo: replace with nordvpn as soon as merged
    # notion-app-enhanced # broken
    gnome-obfuscate # blur data in images, pdfs etc
    pdfslicer
    peek # gif recorder
    pick-colour-picker
    powertop
    gnome.quadrapassel
    rustdesk # for work
    samba
    scc
    signal-desktop
    spotify
    gnome.gnome-sudoku
    gnome.sushi # nautilus file preview
    texlive.combined.scheme-full
    tldr
    typst
    ungoogled-chromium
    ventoy
    vlc
    video-trimmer
    wineWowPackages.stable
    winetricks
    playonlinux
    wl-clipboard # for emote
    xdotool
    zoom-us

    nautilus-open-any-terminal
  ];

  #### PROGRAM OPTIONS ####

  # backslide
  dconf.settings."org/gnome/shell/extensions/backslide" = {
    delay = 15;
    random = true;
  };

  # blackbox-terminal
  dconf.settings."com/raggesilver/BlackBox" = {
    use-custom-command = true;
    custom-shell-command = "/etc/profiles/per-user/mavolin/bin/fish";
    font = "JetBrainsMonoNL Nerd Font 11";
    theme-dark = "Japanesque";
    notify-process-completion = false;
  };

  # Go
  systemd.user.sessionVariables.GOPATH = "$HOME/.local/share/go";

  # TextEditor
  dconf.settings."org/gnome/TextEditor" = {
    resotre-session = false;
    indent-style = "space";
    tab-width = lib.hm.gvariant.mkUint32 2;
    show-line-numbers = true;
  };

  # Vivaldi
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = "vivaldi.desktop";
    "x-scheme-handler/https" = "vivaldi.desktop";
  };

  #################
  #### MODULES ####
  #################

  programs.chromium = {
    enable = true;
    package = unstable-pkgs.vivaldi; # stable has broken hardware acceleration
    dictionaries = with pkgs.hunspellDictsChromium; [en_GB de_DE en_US];
    extensions = [
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # dark reader
      {id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";} # 1password
      {id = "nffaoalbilbmmfgbnbgppjihopabppdk";} # video speed controller
    ];
  };

  programs.direnv = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
  };
  home.sessionVariables.MOZ_ENABLE_WAYLAND = 1;
}
