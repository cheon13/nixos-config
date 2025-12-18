{ pkgs, ... }:

{
  # Installation du display manager gnome
  #services.xserver.enable = true;
  services.displayManager.gdm.enable = true; 
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs.gnomeExtensions; [ 
      #pop-shell
      caffeine # pour inhiber le screen lock
    ];

  #services.gnome.tracker = {
  #  enable = true;
  #  miners.enable = true;
  #};
}

