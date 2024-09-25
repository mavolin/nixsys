{pkgs, ...}: {
  # applied in user/gnome/default.nix
  services.xserver.xkb.extraLayouts.us-german = {
    description = "US layout with Umlauts, Euro Sign and Acute Accent mapped to AltGr";
    languages = ["eng"];
    symbolsFile = pkgs.writeText "/etc/xkb-ext/symbols/us-german" ''
      xkb_symbols "us-german" {
        include "us(basic)"
        include "level3(ralt_switch)"

        key <AE01> { [ 1, exclam, exclamdown ] };
        key <LSGT> { [ dead_acute, space, questiondown ] };
        key <LatA> { [ a, A, adiaeresis, Adiaeresis ] };
        key <LatE> { [ e, E, EuroSign ] };
        key <LatO> { [ o, O, odiaeresis, Odiaeresis ] };
        key <LatU> { [ u, U, udiaeresis, Udiaeresis ] };
        key <LatS> { [ s, S, ssharp, section ] };
        key <LatN> { [ n, N, ntilde, Ntilde ] };
      };
    '';
  };
}
