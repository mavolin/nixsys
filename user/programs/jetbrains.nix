{ pkgs, ... }:
{
  home.packages =
    with pkgs.jetbrains;
    let
      defaultPlugins = [ "github-copilot--your-ai-pair-programmer" ];
      addPlugins = ide: extra: plugins.addPlugins ide (defaultPlugins ++ extra);
    in
    [
      (addPlugins clion [ ])
      (addPlugins datagrip [ ])
      (addPlugins goland [ ])
      (addPlugins idea [ ])
      (addPlugins phpstorm [ ])
      (addPlugins rust-rover [ ])
      (addPlugins webstorm [ ])
    ];
}
