# Home.nix de serveur

{ config, pkgs, inputs, ...}:

{
  imports =
    [ 
      ../../modules/home-manager
    ];

  home.packages = with pkgs; [
    # ajouter les packages propres à serveur
    pcmanfm
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "pcmanfm.desktop";
    };
  };

  home.stateVersion = "23.11";

}
