# Home.nix de pomme

{ config, pkgs, inputs, ...}:

{
  imports =
    [ 
      ../../modules/home-manager
      ../../modules/home-manager/courriel.nix
    ];

  home.stateVersion = "25.11";

  home.packages = with pkgs; [ 
    google-chrome
    spotify
    # Pour les livres numérique
    foliate
  ];

}
