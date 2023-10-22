{pkgs, ...}: {
  # applied in user/gnome/default.nix
  services.xserver.extraLayouts.us-german = {
    description = "US layout with Umlauts and Euro Sign mapped to Alt/AltGR";
    languages = ["eng"];
    symbolsFile = pkgs.writeText "/etc/xkb-ext/symbols/us-german" ''
      xkb_symbols "us-german" {
        include "us(basic)"
        include "level3(ralt_switch)"

        key <LatA> { [ a, A, adiaeresis, Adiaeresis ] };
        key <LatE> { [ e, E, EuroSign ] };
        key <LatO> { [ o, O, odiaeresis, Odiaeresis ] };
        key <LatU> { [ u, U, udiaeresis, Udiaeresis ] };
        key <LatS> { [ s, S, ssharp, section ] };
      };
    '';
  };
}
