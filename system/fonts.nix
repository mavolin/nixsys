{pkgs, ...}: {
  fonts = {
    fontconfig = {
      enable = true;

      defaultFonts = {
        monospace = ["JetBrains Mono"];
        # actually, this is the whatsapp-emoji-font, but for some reason it
        # gets installed as "Apple Color Emoji"
        emoji = ["Apple Color Emoji"];
      };
    };

    packages = with pkgs; [
      whatsapp-emoji-font

      dejavu_fonts
      liberation_ttf
      corefonts
      noto-fonts
      gyre-fonts
      ubuntu_font_family
      cascadia-code
      fira
      fira-mono
      fira-code
      jetbrains-mono
      meslo-lg
      merriweather
      merriweather-sans
      noto-fonts-monochrome-emoji
      open-sans
      roboto
      roboto-slab
      roboto-mono
      inter
      cm_unicode
      (nerdfonts.override {
        fonts = ["FiraCode" "JetBrainsMono"];
      })
    ];
  };
}
