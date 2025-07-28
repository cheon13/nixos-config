{ pkgs, ... }:

{
  # Installation du display manager gnome
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true; 
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs.gnomeExtensions; [ 
      pop-shell
      caffeine
    ];

}

