{unstable-pkgs, ...}: {
  home.packages = with unstable-pkgs.jetbrains; let
    addPlugins = ide: extra:
      plugins.addPlugins ide (["github-copilot"] ++ extra);
  in [
    (addPlugins clion [])
    (addPlugins datagrip [])
    (addPlugins goland [])
    (addPlugins idea-ultimate [])
    (addPlugins phpstorm [])
    (addPlugins rust-rover [])
    (addPlugins webstorm [])
  ];
}
