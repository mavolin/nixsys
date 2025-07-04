{ pkgs, ... }:
{
  home.packages =
    with pkgs.jetbrains;
    let
      defaultPlugins = [ pkgs.jetbrains.plugins.github-copilot-fixed ];
      addPlugins = ide: extra: plugins.addPlugins ide (defaultPlugins ++ extra);
    in
    [
      (addPlugins clion [ ])
      (addPlugins datagrip [ ])
      (addPlugins goland [ ])
      (addPlugins idea-ultimate [ ])
      (addPlugins phpstorm [ ])
      (addPlugins rust-rover [ ])
      (addPlugins webstorm [ ])
    ];
}
