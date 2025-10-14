{
  stdenv,
  makeWrapper,
  pkgs,
  ...
}:
stdenv.mkDerivation {
  pname = "renew";
  version = "4.1";
  src = ./src;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r ./dist $out/dist

    makeWrapper ${pkgs.jre}/bin/java $out/bin/renew \
      --add-flags "-p $out/dist:$out/dist/libs -m de.renew.loader gui"

    mkdir -p $out/share/applications
    cp Renew.desktop $out/share/applications/
    sed -i "s|\\\$out|$out|g" $out/share/applications/Renew.desktop

    mkdir -p $out/share/icons/hicolor/512x512/apps
    cp logo.png $out/share/icons/hicolor/512x512/apps/renew.png
  '';
}
