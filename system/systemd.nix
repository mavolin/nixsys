{ unstable-pkgs, ... }:
{
  systemd = {
    package = unstable-pkgs.systemd; # todo switch to stable on 25.05
  };
}
