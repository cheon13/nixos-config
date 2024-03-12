{ pkgs, ... }:

{
  # Installation du display manager sddm
  services.xserver.displayManager.sddm = {
    enable = true;
    #theme = " "  ;
  }; 
}
