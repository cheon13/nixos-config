{
  description = "Ma configuration NixOS flake de mes ordinateurs";

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    #nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11";
    #home-manager.url = "github:nix-community/home-manager";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #stylix.url = "github:danth/stylix";
    nixvim.url = "github:nix-community/nixvim/nixos-25.11";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      #self,
      nixpkgs,
      home-manager,
      #stylix,
      nixvim,
      ...
    }@inputs:

    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;
        };
      };

    in
    {

      nixosConfigurations = {
        serveur = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit system; };
          modules = [
            ./hotes/serveur/configuration.nix
            #stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cheon = import ./hotes/serveur/home.nix;
              home-manager.backupFileExtension = "backup";
              home-manager.sharedModules = [
                inputs.nixvim.homeModules.nixvim
              ];
            }
          ];
        };

        portable = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit system; };
          modules = [
            ./hotes/portable/configuration.nix
            #stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cheon = import ./hotes/portable/home.nix;
              home-manager.sharedModules = [
                inputs.nixvim.homeModules.nixvim
              ];
            }
          ];
        };

        pomme = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit system; };
          modules = [
            ./hotes/portable/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cheon = import ./hotes/pomme/home.nix;
              home-manager.sharedModules = [
                inputs.nixvim.homeModules.nixvim
              ];
            }
          ];
        };

      };

    };
}
