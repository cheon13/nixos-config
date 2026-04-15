{
  description = "Ma configuration NixOS flake de mes ordinateurs";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim/nixos-25.11";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";                          # nouveau
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";                     # nouveau
    claude-code.url = "github:sadjow/claude-code-nix";
    claude-code.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixvim,
      sops-nix,                                                        # nouveau
      claude-code,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    claudePkg = claude-code.packages.${system}.claude-code;  # nouveau
    in
    {
      nixosConfigurations = {
        serveur = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
            inherit pkgs-unstable;
            inherit claudePkg;                              # nouveau
          };
          modules = [
            ./hotes/serveur/configuration.nix
            sops-nix.nixosModules.sops                                 # nouveau
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cheon = import ./hotes/serveur/home.nix;
              home-manager.backupFileExtension = "backup";
              home-manager.sharedModules = [
                inputs.nixvim.homeModules.nixvim
                sops-nix.homeManagerModules.sops                       # nouveau
              ];
            }
          ];
        };
        portable = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
            inherit pkgs-unstable;
            inherit claudePkg;                              # nouveau
          };
          modules = [
            ./hotes/portable/configuration.nix
            sops-nix.nixosModules.sops                                 # nouveau
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cheon = import ./hotes/portable/home.nix;
              home-manager.backupFileExtension = "backup";
              home-manager.sharedModules = [
                inputs.nixvim.homeModules.nixvim
                sops-nix.homeManagerModules.sops                       # nouveau
              ];
            }
          ];
        };
        pomme = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
            inherit pkgs-unstable;
            inherit claudePkg;                              # nouveau
          };
          modules = [
            ./hotes/pomme/configuration.nix
            sops-nix.nixosModules.sops                                 # nouveau
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cheon = import ./hotes/pomme/home.nix;
              home-manager.backupFileExtension = "backup";
              home-manager.sharedModules = [
                inputs.nixvim.homeModules.nixvim
                sops-nix.homeManagerModules.sops                       # nouveau
              ];
            }
          ];
        };
      };
    };
}
