# Home.nix 

{ config, pkgs, inputs, ...}:

{
  imports =
    [ 
      ../../modules/home-manager
    ];

  home.stateVersion = "24.05";

}
