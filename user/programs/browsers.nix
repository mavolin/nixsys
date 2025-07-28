{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.vivaldi; # stable has broken hardware acceleration
    dictionaries =
      let
        mkDictFromChromium =
          {
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
              license = with lib.licenses; [
                gpl2
                lgpl21
                mpl11
                lgpl3
              ];
              maintainers = with lib.maintainers; [ networkexception ];
              platforms = lib.platforms.all;
            };
          };
        es_ES = mkDictFromChromium {
          shortName = "es-ES";
          dictFileName = "es-ES-3-0.bdic";
          shortDescription = "Spanish (Spain)";
        };
      in
      with pkgs.hunspellDictsChromium;
      [
        en_GB
        de_DE
        en_US
        es_ES
      ];
    extensions = [
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # dark reader
      { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1password
      { id = "nffaoalbilbmmfgbnbgppjihopabppdk"; } # video speed controller
    ];
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
  };
  home.sessionVariables.MOZ_ENABLE_WAYLAND = 1;

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = "vivaldi.desktop";
    "x-scheme-handler/https" = "vivaldi.desktop";
  };
}
