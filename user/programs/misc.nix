{
  pkgs,
  unstable-pkgs,
  lib,
  ...
}:
{
  ##################
  #### PROGRAMS ####
  ##################

  home.packages = with pkgs; [
    aisleriot
    angryipscanner
    any-nix-shell
    apostrophe
    ausweisapp
    blackbox-terminal
    bottles
    gnome-boxes
    gnome-chess
    calibre
    ciano # converter
    contrast
    collision # hash checker
    dconf-editor
    ddrescue
    discord
    dive
    drawing
    drawio
    emote
    filezilla
    fortune # fortune cookie message cli
    lorem
    gcolor3
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
    gnome-mahjongg
    meld
    minder
    networkmanager-openconnect
    gnome-nettool
    # nordvpn # todo: replace with nordvpn as soon as merged
    gnome-obfuscate # blur data in images, pdfs etc
    pdfslicer
    powertop
    quadrapassel
    rustdesk-flutter
    samba
    scc
    signal-desktop
    spotify
    gnome-sudoku
    texlive.combined.scheme-full
    unstable-pkgs.tinymist
    tldr
    typst
    typstyle
    # ventoy
    virt-manager
    vlc
    video-trimmer
    wineWowPackages.stable
    winetricks
    wl-clipboard # for emote
    xdotool
    zoom-us
  ];

  #### PROGRAM OPTIONS ####

  # 1password
  # installed at system level, but the file is in user home
  home.sessionVariables.SSH_AUTH_SOCK = "$HOME/.1password/agent.sock";

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

  #################
  #### MODULES ####
  #################

  programs.direnv = {
    enable = true;
  };
}
