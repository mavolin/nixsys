{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        identityAgent = "~/.1password/agent.sock";
      };
    } // import ../../secrets/ssh-hosts.nix;
  };
}
