{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./extensions.nix
  ];

  #################
  #### THEMING ####
  #################

  gtk = {
    enable = true;
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
  };
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";

    font-name = "Inter 11";
    document-font-name = "Inter 11";
    monospace-font-name = "JetBrains Mono 10";
  };

  ################
  #### TOP BAR ###
  ################

  dconf.settings."org/gnome/desktop/interface" = {
    show-battery-percentage = true;
    clock-format = "24h";
    clock-show-date = true;
    clock-show-seconds = true;
    clock-show-weekday = true;
  };

  #####################
  #### KEYBINDINGS ####
  #####################

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      sources = [
        (lib.hm.gvariant.mkTuple [
          "xkb"
          "us-german"
        ])
      ];
    };

    "org/gnome/mutter".experimental-features = [ "scale-monitor-framebuffer" ];

    "org/gnome/desktop/wm/keybindings" =
      let
        mkWorkspaceKeybindings =
          i:
          if i >= 1 then
            {
              "switch-to-application-${toString i}" = [ ];
              "switch-to-workspace-${toString i}" = [ "<Super>${toString i}" ];
              "move-to-workspace-${toString i}" = [ "<Super><Shift>${toString i}" ];
            }
            // mkWorkspaceKeybindings (i - 1)
          else
            { };
      in
      mkWorkspaceKeybindings 5
      // {
        close = [ "<Super>q" ];
      };
    "org/gnome/shell/keybindings" =
      let
        # delete switch-to-applications keybindings conflicting w/
        # these
        mkWorkspaceKeybindings =
          i:
          if i >= 1 then
            { "switch-to-application-${toString i}" = [ ]; } // mkWorkspaceKeybindings (i - 1)
          else
            { };
      in
      mkWorkspaceKeybindings 5;

    "org/gnome/settings-daemon/plugins/media-keys" = {
      calculator = [ "<Super>c" ];
      home = [ "<Super>f" ];
      www = [ "<Super>b" ];

      custom-keybindings =
        let
          mkPath =
            start: end:
            if start <= end then
              [
                ("/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom" + (toString start) + "/")
              ]
              ++ (mkPath (start + 1) end)
            else
              [ ];
        in
        mkPath 0 3;
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      command = "blackbox";
      name = "Terminal";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>period";
      command = "smile";
      name = "Emoji Picker";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Ctrl><Shift>space";
      command = "1password --quick-access --ozone-platform=wayland";
      name = "1Password Quick Access";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      binding = "<Super>e";
      command = "geary";
      name = "Geary";
    };
  };

  ##############################
  #### STARTUP APPLICATIONS ####
  ##############################

  # https://github.com/nix-community/home-manager/issues/3447#issuecomment-1328294558
  xdg.configFile =
    let
      autostartApps = [
        {
          pkg = pkgs._1password-gui;
          args = "--silent --ozone-platform=wayland";
        }
        { pkg = pkgs.whatsapp-for-linux; }
      ];

      mkAutostartEntries =
        i:
        if i < (builtins.length autostartApps) then
          let
            autostart = builtins.elemAt autostartApps i;
          in
          {
            "autostart/${autostart.cmd or autostart.pkg.pname}.desktop".text = ''
              [Desktop Entry]
              Type=Application
              Name=${autostart.cmd or autostart.pkg.pname}
              Exec=${autostart.cmd or autostart.pkg.pname} ${autostart.args or ""}
            '';
          }
          // mkAutostartEntries (i + 1)
        else
          { };
    in
    mkAutostartEntries 0;

  ########################
  #### SCREEN DIMMING ####
  ########################

  dconf.settings = {
    "org/gnome/desktop/session" = {
      # time after which the screen turns blank
      idle-delay = lib.hm.gvariant.mkUint32 (15 * 60); # sec
    };
    "org/gnome/desktop/screensaver" = {
      # time after which after the screen turned blank, the session locks
      lock-delay = 15; # sec
      lock-enabled = true;
    };
  };

  ##############
  #### MISC ####
  ##############

  dconf.settings = {
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = true;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
    };
    "org/gnome/desktop/privacy" = {
      # how long to keep trash and temp files
      old-files-age = 15; # days
      remove-old-temp-files = true;
      remove-old-trash-files = true;
    };
    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = true;
    };

    "org/gnome/shell" = {
      # pinned apps in the dock
      favorite-apps = [ ];
    };
  };
}
