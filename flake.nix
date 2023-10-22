{
  description = "mavolin's nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tuxedo-nixos = {
      url = "github:blitz/tuxedo-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    tuxedo-nixos,
  } @ inputs: let
    # Change base.nix to edit the most common settings.
    base = import ./base.nix;
    specialArgs = inputs // {inherit base;};
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    nixosConfigurations = {
      ${base.hostname} = nixpkgs.lib.nixosSystem {
        inherit (base) system;
        inherit specialArgs;
        modules = [
          ./system/configuration.nix
          tuxedo-nixos.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${base.username} = import ./user;
              extraSpecialArgs = specialArgs;
            };
          }
        ];
      };
    };
  };
}
