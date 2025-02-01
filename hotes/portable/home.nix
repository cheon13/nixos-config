# Home.nix 

{ config, pkgs, inputs, ...}:

{
  imports =
    [ 
      ../../modules/home-manager
    ];

  home.packages = with pkgs; [ 
    google-chrome
    brave
  ];

  home.stateVersion = "24.05";

}
