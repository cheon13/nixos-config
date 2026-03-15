# Home.nix de pomme

{ config, pkgs, inputs, ...}:

{
  imports =
    [ 
      ../../modules/home-manager
    ];

  home.stateVersion = "25.11";

  home.packages = with pkgs; [ 
    google-chrome
    spotify
    # Pour les livres numérique
    foliate
  ];

}
