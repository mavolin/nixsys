{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    extensions = with pkgs.vscode-extensions;
      [
        github.copilot
        nvarner.typst-lsp
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "intellij-idea-keybindings";
          publisher = "k--kato";
          version = "1.5.12";
          sha256 = "sha256-khXO8zLwQcdqiJxFlgLQSQbVz2fNxFY6vGTuD1DBjlc=";
        }
      ];
  };
}
