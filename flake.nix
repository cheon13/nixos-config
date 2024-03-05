{
  description = "Ma configuration NixOS flake de serveur";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    #nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nixos-wsl, ... }: 
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
        ./hotes/wsl-portable/configuration.nix
        nixos-wsl.nixosModules.wsl
        home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.cheon = import ./hotes/wsl-portable/home.nix;
	  }
       ];
     };
    };

    };
}
