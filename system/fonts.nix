{ pkgs, ... }:
{
  fonts = {
    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        autohint = true;
        style = "none";
      };
      subpixel.rgba = "rgb";

      defaultFonts = {
        monospace = [ "JetBrains Mono" ];
        # actually, this is the whatsapp-emoji-font, but for some reason it
        # gets installed as "Apple Color Emoji"
        emoji = [ "Apple Color Emoji" ];
      };

      useEmbeddedBitmaps = true;
    };

    packages =
      with pkgs;
      [
        whatsapp-emoji-font

        dejavu_fonts
        liberation_ttf
        corefonts
        cantarell-fonts
        noto-fonts
        ubuntu_font_family
        cascadia-code
        fira-code
        fira-mono
        fira-sans
        go-font
        inter
        jetbrains-mono
        meslo-lg
        merriweather
        merriweather-sans
        noto-fonts-monochrome-emoji
        open-sans
        rubik
        roboto
        roboto-slab
        roboto-mono

        cm_unicode
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
      ]
      ++ (lib.attrValues tex-gyre)
      ++ (lib.attrValues tex-gyre-math);
  };
}
