# This overlay provides a fixed version of the GitHub Copilot plugin for JetBrains IDEs.
# Borrowed from https://github.com/SamueleFacenda/nixos-config/blob/c3df35b40b7e501398ebf7cb53ed0115d65733d9/overlays/jetbrains-plugins.nix
# Fixes https://github.com/NixOS/nixpkgs/issues/400317
# Original plugin handling on https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/editors/jetbrains/plugins/specialPlugins.nix#L47

final: prev:
let
  id = "17718";
  # Check version and update URL from https://plugins.jetbrains.com/plugin/17718-github-copilot/versions
  url = "https://plugins.jetbrains.com/files/17718/786198/github-copilot-intellij-1.5.48-243.zip";
  hash = "sha256-OTe127sq47oE6EX3QiVJH3M6Ti0yuSgoav5aR4spbHE=";

  # Combine URL and hash to create a unique identifier for the plugin to fix re-evaluation issues
  combined = "${url}-${hash}";
  fullHash = builtins.hashString "sha256" combined;
  shortHash = builtins.substring 0 8 fullHash;
in
{
  jetbrains = prev.lib.recursiveUpdate prev.jetbrains {
    plugins.github-copilot-fixed = prev.stdenv.mkDerivation {
      name = "jetbrains-plugin-${id}-github-copilot-fixed-${shortHash}";
      installPhase = ''
        runHook preInstall
        mkdir -p $out && cp -r . $out
        runHook postInstall
      '';
      src = prev.fetchzip {
        inherit url;
        inherit hash;
        executable = false;
      };

      # prelude
      # (function(process, require, console, EXECPATH_FD, PAYLOAD_POSITION, PAYLOAD_SIZE) { return (function (REQUIRE_COMMON, VIRTUAL_FILESYSTEM, DEFAULT_ENTRYPOINT, SYMLINKS, DICT, DOCOMPRESS) {
      # payload
      # grep -aobUam1 $'\x1f\x8b\x08\x00' copilot-language-server

      buildPhase = ''
        agent='copilot-agent/native/${prev.lib.toLower prev.stdenv.hostPlatform.uname.system}${
          {
            x86_64 = "-x64";
            aarch64 = "-arm64";
          }
          .${prev.stdenv.hostPlatform.uname.processor} or ""
        }/copilot-language-server'

        # Helper: find the offset of the payload by matching gzip magic bytes
        find_payload_offset() {
          grep -aobUam1 -f <(printf '\x1f\x8b\x08\x00') "$agent" | cut -d: -f1
        }

        # Helper: find the offset of the prelude by searching for function string start
        find_prelude_offset() {
          local prelude_string='(function(process, require, console, EXECPATH_FD, PAYLOAD_POSITION, PAYLOAD_SIZE) {'
          grep -obUa -- "$prelude_string" "$agent" | cut -d: -f1
        }

        before_payload_position="$(find_payload_offset)"
        before_prelude_position="$(find_prelude_offset)"

        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $agent
        patchelf --set-rpath ${
          prev.lib.makeLibraryPath [
            prev.glibc
            prev.gcc-unwrapped
          ]
        } $agent
        chmod +x $agent

        after_payload_position="$(find_payload_offset)"
        after_prelude_position="$(find_prelude_offset)"

        # There are hardcoded positions in the binary, then it replaces the placeholders by himself
        sed -i -e "s/$before_payload_position/$after_payload_position/g" "$agent"
        sed -i -e "s/$before_prelude_position/$after_prelude_position/g" "$agent"
      '';
    };
  };
}
