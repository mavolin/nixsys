{
  base,
  pkgs,
  unstable-pkgs,
  config,
  lib,
  ...
}: {
  ##################
  #### PROGRAMS ####
  ##################

  home.packages = with pkgs; [
    gnome.aisleriot
    angryipscanner
    any-nix-shell
    apostrophe
    ausweisapp
    blackbox-terminal
    bottles
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
    unstable-pkgs.rustdesk-flutter # for work, only in unstable for now
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
    wl-clipboard # for emote
    xdotool
    zoom-us

    nautilus-open-any-terminal
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
    dictionaries = let
      mkDictFromChromium = {
        shortName,
        dictFileName,
        shortDescription,
      }:
        with pkgs;
          stdenv.mkDerivation {
            pname = "hunspell-dict-${shortName}-chromium";
            version = "115.0.5790.170";

            src = fetchgit {
              url = "https://chromium.googlesource.com/chromium/deps/hunspell_dictionaries";
              rev = "41cdffd71c9948f63c7ad36e1fb0ff519aa7a37e";
              hash = "sha256-67mvpJRFFa9eMfyqFMURlbxOaTJBICnk+gl0b0mEHl8=";
            };

            dontBuild = true;

            installPhase = ''
              cp ${dictFileName} $out
            '';

            passthru = {
              # As chromium needs the exact filename in ~/.config/chromium/Dictionaries,
              # this value needs to be known to tools using the package if they want to
              # link the file correctly.
              inherit dictFileName;

              updateScript = ./update-chromium-dictionaries.py;
            };

            meta = {
              homepage = "https://chromium.googlesource.com/chromium/deps/hunspell_dictionaries/";
              description = "Chromium compatible hunspell dictionary for ${shortDescription}";
              longDescription = ''
                Humspell directories in Chromium's custom bdic format

                See https://www.chromium.org/developers/how-tos/editing-the-spell-checking-dictionaries/
              '';
              license = with lib.licenses; [gpl2 lgpl21 mpl11 lgpl3];
              maintainers = with lib.maintainers; [networkexception];
              platforms = lib.platforms.all;
            };
          };
      es_ES = mkDictFromChromium {
        shortName = "es-ES";
        dictFileName = "es-ES-3-0.bdic";
        shortDescription = "Spanish (Spain)";
      };
    in
      with pkgs.hunspellDictsChromium; [en_GB de_DE en_US es_ES];
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
