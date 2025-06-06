{
  base,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    aspell
    aspellDicts.de
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.es
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_GB-large
    hunspellDicts.en_US
    hunspellDicts.es_ES

    nixd
    nixfmt-rfc-style
    samba
  ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ base.username ];
  };
  environment.etc."1password/custom_allowed_browsers" = {
    text = "vivaldi-bin";
    mode = "0644";
  };

  services.dbus.enable = true;

  programs.steam.enable = true;
}
