{
  description = "mavolin's nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixos-hardware,
      home-manager,
    }:
    let
      # Change base.nix to edit the most common settings.
      base = import ./base.nix;

      overlayDirPath = ./overlays;
      overlayDir = builtins.readDir overlayDirPath;
      overlaysDirFiles = builtins.filter (name: (builtins.match "\.nix$" name) != null) (builtins.attrNames overlayDir);
      overlaysFromDir = builtins.map (file: import "${overlayDir}/${file}") overlaysDirFiles;

      unstable-pkgs = import nixpkgs-unstable {
        inherit (base) system;
        config.allowUnfree = true;
        overlays = overlaysFromDir;
      };

      specialArgs = {
        inherit base unstable-pkgs;
        derivations = import ./derivations {
          pkgs = nixpkgs.legacyPackages.${base.system};
        };
      };
    in
    {
      formatter.${base.system} = nixpkgs.legacyPackages.${base.system}.nixfmt-tree;

      nixosConfigurations = {
        ${base.hostname} = nixpkgs.lib.nixosSystem {
          inherit (base) system;
          inherit specialArgs;
          modules = [
            ./system/configuration.nix
            home-manager.nixosModules.home-manager
            nixos-hardware.nixosModules.tuxedo-infinitybook-pro14-gen9-amd
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${base.username} = import ./user;
                extraSpecialArgs = specialArgs;
              };
              nixpkgs.overlays = overlaysFromDir;
            }
          ];
        };
      };
    };
}
