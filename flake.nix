{
 description = "Ma configuration NixOS flake de serveur";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    #nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = { self, nixpkgs, home-manager, nixos-wsl, stylix, nixvim, ... }@inputs: 
  #outputs = { self, nixpkgs, home-manager, ... }: 
  #outputs = inputs: 
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
        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.cheon = import ./hotes/serveur/home.nix;
	       }
       ];
     };
     portable = nixpkgs.lib.nixosSystem {
       specialArgs = { inherit system; };
       modules = [
        ./hotes/portable/configuration.nix
        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.cheon = import ./hotes/portable/home.nix;
	       }
        nixvim.homeManagerModules.nixvim
        #nixvim.nixosModules.nixvim
       ];
     };
     wsl-portable = nixpkgs.lib.nixosSystem {
       specialArgs = { inherit system; };
       modules = [
        nixos-wsl.nixosModules.wsl (import ./hotes/wsl-portable/configuration.nix inputs)
        home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.cheon = import ./hotes/wsl-portable/home.nix;
	  }
       ];
     };
     customIso = nixpkgs.lib.nixosSystem {
       specialArgs = { inherit inputs; };
       modules = [
         ./hotes/isoImage/configuration.nix
       ];
     };

    };

    };
}
