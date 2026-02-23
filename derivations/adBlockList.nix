{
  stdenv,
  hblock,
  adBlockListFiles,
}:

stdenv.mkDerivation {
  name = "adBlockList";

  nativeBuildInputs = [ hblock ];

  dontUnpack = true;

  buildPhase = ''
    touch block.txt
    for file in ${builtins.concatStringsSep " " adBlockListFiles}; do
      cat "$file" >> block.txt
      echo "" >> block.txt # add a newline between files
    done
  '';

  installPhase = ''
    mkdir -p $out

    # run hblock
    hblock \
      --output "$out/hosts" \
      --header none \
      --footer none \
      --sources none \
      --denylist block.txt
  '';
}
