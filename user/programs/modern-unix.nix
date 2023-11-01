{pkgs, ...}: {
  home.packages = with pkgs; [
    bat
    lsd
    delta
    du-dust
    duf
    ripgrep
    jq
    tldr
    gtop
    gping
    dogdns
  ];

  programs.fish = {
    shellAliases = {
      cat = "bat";
      ls = "lsd --group-dirs=first --color=auto";
      delta = "delta -sn";
      du = "dust";
    };
    shellAbbrs = {
      l = "ls";
      ll = "ls -l";
      la = "ls -A";
      p = "gping";
      dog = "dog A AAAA";
    };
  };

  programs.zoxide = {
    enable = true;
  };
}
