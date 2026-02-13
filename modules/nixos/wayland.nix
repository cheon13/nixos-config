{ config, pkgs, ... }:

{
  # Wayland and Sway config
  ## Hardware Support for Wayland (Sway+Hyprland+River)
  hardware = {
    graphics = { # changé opengl à graphics
      enable = true;
      # driSupport = true; the option definition 'hardware.opengl.driSupport  no longer  has any effect
    };
  };

  ## XDG config for wayland 
  xdg = {
    portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        #xdg-desktop-portal-gtk # déactiver cet ligne si utilisation de gnome
        xdg-desktop-portal-gnome 
      ];
    };
  };
  
  ## Allow swaylock to unlock the computer for us
  security.pam.services.swaylock = {
    text = "auth include login";
  };

}
