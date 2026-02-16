{
  pkgs,
  lib,
  ...
}:
let
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
  gitSettings = import ../../secrets/git-settings.nix;

  githubServer = lib.lists.findFirst (server: server.url == "github.com") null gitSettings;
in
{
  programs.git = {
    enable = true;
    includes =
      let
        mkCodeInclude = server: {
          condition = "gitdir:~/Code/${server.url}/";
          contents = mkConfig server;
        };
        mkNixsysInclude = server: {
          condition = "gitdir:~/nixsys/";
          contents = mkConfig server;
        };
        mkConfig = server: {
          user = {
            name = server.username;
            email = server.email;
            signingkey = server.signingkey;
          };
          gpg = {
            format = "ssh";
            ssh = {
              program = "${pkgs._1password-gui + "/share/1password/op-ssh-sign"}";
            };
          };
          commit = {
            gpgsign = true;
          };
        };
      in
      (map mkCodeInclude gitSettings)
      ++ (lib.optional (githubServer != null) (mkNixsysInclude githubServer));
    ignores = [
      ".direnv/"
      "testlocal/"
      ".idea/"
      "todo"
      ".gitconfig"
    ];
    settings = {
      init = {
        defaultBranch = "v0";
      };
      fetch = {
        prune = true;
      };
      pull = {
        ff = "only";
        rebase = true;
      };
      push = {
        autoSetupRemote = true;
      };
    };
  };

  programs.mergiraf.enable = true;
}
