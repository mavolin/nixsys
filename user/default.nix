{
  base,
  pkgs,
  ...
} @ inputs: {
  imports = [
    ./gnome
    ./programs
  ];

  home = {
    username = base.username;
    inherit (base) stateVersion;
  };

  programs.home-manager.enable = true;
}
