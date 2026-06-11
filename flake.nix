{
  description = "Ma configuration NixOS flake de mes ordinateurs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    #home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
    #nixvim.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    claude-code.url = "github:sadjow/claude-code-nix";
    claude-code.inputs.nixpkgs.follows = "nixpkgs";

    # Mon fork personnel de DWL (suit la branche mon-dwl).
    # flake = false : on récupère seulement les sources, le build est défini
    # dans modules/nixos/dwl.nix.
    mon-dwl = {
      url = "github:cheon13/mon-dwl/mon-dwl";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixvim,
      sops-nix,
      claude-code,
      mon-dwl,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      claudePkg = claude-code.packages.${system}.claude-code;

      mkHost = hote: nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit system pkgs-unstable claudePkg;
          dwlSrc = mon-dwl;
        };
        modules = [
          ./hotes/${hote}/configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.cheon = import ./hotes/${hote}/home.nix;
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit pkgs-unstable; };
              sharedModules = [
                inputs.nixvim.homeModules.nixvim
                sops-nix.homeManagerModules.sops
              ];
            };
          }
        ];
      };
    in
    {
      nixosConfigurations = {
        serveur  = mkHost "serveur";
        portable = mkHost "portable";
        pomme    = mkHost "pomme";
      };
    };
}
