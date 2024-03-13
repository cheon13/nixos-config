{ pkgs, ... }:

{
  # Installation du display manager sddm
  services.xserver.enable = true;
  services.xserver.displayManager.sddm = {
    enable = true;
    #wayland.enable = true;
    #theme = " "  ;
  }; 
}
