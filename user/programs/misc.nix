{
  base,
  pkgs,
  config,
  lib,
  ...
}: {
  ##################
  #### PROGRAMS ####
  ##################

  home.packages =
    (with pkgs; [
      gnome.aisleriot
      any-nix-shell
      apostrophe
      biber # for texlive/biblatex
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
      # lorem # to be merged https://github.com/NixOS/nixpkgs/issues/195280
      geogebra6
      gimp
      gnumake
      go
      gotools
      gofumpt
      golangci-lint
      gparted
      gthumb
      inkscape
      pstoedit # latter for opening .eps
      jdk17
      john
      libsForQt5.kdenlive
      less
      libreoffice-fresh
      gnome.gnome-mahjongg
      meld
      minder
      gnome.gnome-nettool
      # nordvpn # todo: replace with nordvpn as soon as merged
      notion-app-enhanced
      gnome-obfuscate # blur data in images, pdfs etc
      pdfslicer
      peek # gif recorder
      pick-colour-picker
      popsicle # usb flasher, since gnome's impression isn't in nixpkgs
      powertop
      killall
      gnome.quadrapassel
      samba
      scc
      signal-desktop
      spotify
      gnome.gnome-sudoku
      gnome.sushi # nautilus file preview
      tldr
      ungoogled-chromium
      ventoy
      video-trimmer
      wineWowPackages.stable
      winetricks
      playonlinux
      wl-clipboard # for emote
      xdotool
      zoom

      nautilus-open-any-terminal
    ])
    ++ (with pkgs.jetbrains; let
      addPlugins = ide: extra:
        plugins.addPlugins ide (["github-copilot"] ++ extra);
    in [
      (addPlugins clion [])
      (addPlugins datagrip [])
      (addPlugins goland [])
      (addPlugins idea-ultimate [])
      (addPlugins phpstorm [])
      (addPlugins rust-rover [])
      (addPlugins webstorm [])
    ]);

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
    package = pkgs.vivaldi;
    dictionaries = with pkgs.hunspellDictsChromium; [en_GB de_DE en_US];
    extensions = [
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # dark reader
      {id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";} # 1password
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

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
       IdentityAgent ~/.1password/agent.sock
    '';
  };

  programs.texlive = {
    enable = true;
    extraPackages = texlive: {inherit (texlive) scheme-medium scheme-context;};
  };
}
