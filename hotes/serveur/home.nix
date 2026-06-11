# Home.nix de serveur

{ config, pkgs, inputs, ...}:

{
  imports =
    [ 
      ../../modules/home-manager
    ];

  home.packages = with pkgs; [
    # ajouter les packages propres à serveur
  ];

  home.stateVersion = "23.11";

}
