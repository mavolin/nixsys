{
  description = "mavolin's nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
    }:
    let
      # Change base.nix to edit the most common settings.
      base = import ./base.nix;

      overlayDir = ./overlays;
      overlaysFromDir = builtins.map (file: import "${overlayDir}/${file}") (
        builtins.attrNames (builtins.readDir overlayDir)
      );

      unstable-pkgs = import nixpkgs-unstable {
        inherit (base) system;
        config.allowUnfree = true;
        overlays = overlaysFromDir;
      };
      specialArgs = {
        inherit base;
        inherit unstable-pkgs;
      };
    in
    {
      formatter.${base.system} = nixpkgs.legacyPackages.${base.system}.nixfmt-rfc-style;

      nixosConfigurations = {
        ${base.hostname} = nixpkgs.lib.nixosSystem {
          inherit (base) system;
          inherit specialArgs;
          modules = [
            ./system/configuration.nix
            home-manager.nixosModules.home-manager
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
