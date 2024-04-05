{
  description = "Ma configuration NixOS flake de serveur";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-23.11";
    #nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-wsl, nix-on-droid, ... }@inputs: 
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
        home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.cheon = import ./hotes/serveur/home.nix;
	  }
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

    nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
      modules = [ ./hotes/phone/nix-on-droid.nix ];
    };

    };
}
