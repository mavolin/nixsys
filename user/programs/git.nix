{
  pkgs,
  lib,
  ...
}: let
  # a list of git servers, could look like so:
  #
  # [
  #   {
  #     name = "mavolin";
  #     url = "github.com";
  #     email = "foo@example.com";
  #     signingkey = "ssh-ed25519 ABC123";
  #   }
  # ]
  #
  # it's gitignored, bc i like my privacy
  gitSettings = import ./git-settings.nix;

  githubServer = lib.lists.findFirst (server: server.url == "github.com") null gitSettings;
in {
  programs.git = {
    enable = true;
    includes = let
      mkInclude = url: {
        path = "~/Code/${url}/.gitconfig";
        condition = "gitdir:~/Code/${url}/";
      };
    in
      (map (server: mkInclude server.url) gitSettings)
      ++ (
        if githubServer != null
        then [
          {
            path = "~/nixsys/.gitconfig";
            condition = "gitdir:~/nixsys/";
          }
        ]
        else []
      );
    ignores = [".direnv/" "testlocal/" ".idea/" "todo" ".gitconfig"];
  };

  home.file = let
    mkCfg = {
      name,
      email,
      signingkey,
      ...
    }: ''
      [user]
      name = ${name}
      email = ${email}
      signingkey = ${signingkey}

      [gpg]
      format = ssh

      [gpg "ssh"]
      program = "${pkgs._1password-gui + "/share/1password/op-ssh-sign"}"

      [commit]
      gpgsign = true
    '';
  in
    (builtins.listToAttrs (map (server: {
        name = "Code/${server.url}/.gitconfig";
        value.text = mkCfg server;
      })
      gitSettings))
    // (
      if githubServer != null
      then {"nixsys/.gitconfig".text = mkCfg githubServer;}
      else {}
    );
}
