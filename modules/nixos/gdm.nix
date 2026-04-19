{ ... }:

{
  # Installation du display manager gdm
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true; 
}

