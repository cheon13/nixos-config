{ pkgs, ... }:

{
  # Installation du display manager gnome
  services.xserver.enable = true;
  #services.xserver.displayManager.gdm.enable = true; 
  services.xserver.desktopManager.gnome.enable = true;
}

