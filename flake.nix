{
  description = "mavolin's nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
  } @ inputs: let
    # Change base.nix to edit the most common settings.
    base = import ./base.nix;
    unstable-pkgs = import nixpkgs-unstable {
      inherit (base) system;
      config = {
        allowUnfree = true;
      };
    };
    specialArgs =
      inputs
      // {
        inherit base;
        inherit unstable-pkgs;
      };
  in {
    formatter.${base.system} = nixpkgs.legacyPackages.${base.system}.alejandra;

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
          }
        ];
      };
    };
  };
}
