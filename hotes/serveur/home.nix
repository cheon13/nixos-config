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

  home.file.".xinitrc".text = ''
    # Fichier de configuration pour startx
    #
    # Pour le fond d'écran
    nitrogen --restore &
    # Pour donner le status dans la barre de DWM
    slstatus &
    # La ligne suivant n'est pas nécessaire parce que intercept-tools s'en occupe pour la Console, Wayland et X11
    # setxkbmap -option caps:swapescape
    exec dwm  # cette ligne est nécessaire si les fichiers est .xinitrc, mais pas pour .xprofile
  '';

  home.stateVersion = "23.11";

}
