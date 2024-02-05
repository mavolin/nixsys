{base, ...}: {
  programs.fish = {
    enable = true;

    shellInit = ''
      any-nix-shell fish --info-right | source
    '';
    shellAbbrs = {
      docker = "sudo docker";
      nixdev = "nix develop -c fish";
    };
    shellAliases = {
      sdocker = "sudo systemctl start docker.service";

      sshx = "ssh root@x-lan.de";
      sshr = "ssh root@rocketman.mavolin.co";
      sshm = "ssh root@moonrover.mavolin.co";
    };

    functions = {
      fish_greeting = "fortune";

      reos = ''
        pushd /home/${base.username}/nixsys

        # so nix let's us use the git-settings.nix file
        mv user/programs/.gitignore user/programs/.gitignore.old
        git add user/programs/borgmatic_enc_passphrase
        git add user/programs/borgmatic_ntfy_passwd
        git add user/programs/git-settings.nix


        sudo nixos-rebuild switch --flake .

        mv user/programs/.gitignore.old user/programs/.gitignore
        git reset user/programs/borgmatic_enc_passphrase --quiet
        git reset user/programs/borgmatic_ntfy_passwd --quiet
        git reset user/programs/git-settings.nix --quiet

        popd
      '';
      upos = ''
        pushd /home/${base.username}/nixsys
        sudo echo -n || exit $status # ensure we have sudo so we don't update for nothing
        nix flake update
        reos
        popd
      '';
      nixsh = "nix shell nixpkgs#$argv[1]";

      goget = "go get (echo $argv[1] | sed 's|https://||g')";

      tagv = ''
        argparse -N 1 -X 1 -- $argv; or return 2

        switch $argv[1]
          case 'major'
          case 'minor'
          case 'patch'
          case '*'
            echo invalid argument $argv[1]
            return 1
        end

        set tags (git tag)
        or begin
        	set git_status $status
        	echo $tags
        	return $git_status
        end

        if test (count $tags) -eq 0
          switch $argv[1]
            case 'major'
              git tag -a 'v1.0.0' -m 'Version v1.0.0'
            case 'minor'
              git tag -a 'v0.1.0' -m 'Version v0.1.0'
            case 'patch'
              git tag -a 'v0.0.1' -m 'Version v0.0.1'
          end

          echo (git tag)
          return 0
        end

        set latest_tag (git describe --abbrev=0 --tags)

        set vers (string match -rg 'v(\d+)\.(\d+)\.(\d+)' $latest_tag);
        or echo $latest_tag is not a valid semver version

        set major $vers[1]
        set minor $vers[2]
        set patch $vers[3]


        set new_tag
        switch $argv[1]
          case 'major'
            set new_tag "v$(math $major + 1).0.0"
          case 'minor'
            set new_tag "v$major.$(math $minor + 1).0"
          case 'patch'
            set new_tag "v$major.$minor.$(math $patch + 1)"
        end

        git tag -a $new_tag -m "Version $new_tag"; or return $status
        echo $new_tag
      '';
    };
  };

  xdg.configFile."fish/completions/tagv.fish".text = ''
    complete -c tagv -f
    complete -c tagv -ka 'patch' -d 'Increase patch by one'
    complete -c tagv -ka 'minor' -d 'Increase minor by one'
    complete -c tagv -ka 'major' -d 'Increase major by one'
  '';
}
