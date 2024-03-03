{ config, pkgs, ... }:

{
  # Wayland and Sway config
  ## Hardware Support for Wayland (Sway+Hyprland)
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  ## XDG config for wayland 
  xdg = {
    portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };
  
  ## Allow swaylock to unlock the computer for us
  security.pam.services.swaylock = {
    text = "auth include login";
  };

}
