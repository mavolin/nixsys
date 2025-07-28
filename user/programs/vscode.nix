{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default.extensions = with pkgs.vscode-extensions; [
      github.copilot
      myriad-dreamin.tinymist
      k--kato.intellij-idea-keybindings
      tomoki1207.pdf
    ];
  };
}
