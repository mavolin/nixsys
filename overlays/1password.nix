final: prev: {
  _1password-gui = prev._1password-gui.overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      substituteInPlace $out/share/applications/1password.desktop \
        --replace "Exec=1password" "Exec=1password --disable-gpu-sandbox"
    '';
  });
}