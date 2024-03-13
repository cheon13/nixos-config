{ pkgs, ... }:

{
  # Installation du display manager sddm
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true; 
}

