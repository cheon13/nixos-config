{ pkgs, ... }:

{
  hardware.graphics.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr      # compositeurs wlroots : Sway, DWL, River
      xdg-desktop-portal-hyprland # Hyprland (portail dédié wlroots)
      xdg-desktop-portal-gtk      # fallback GTK pour les applications GTK
      xdg-desktop-portal-gnome    # GNOME et Niri
    ];
    config = {
      # Fallback si XDG_CURRENT_DESKTOP n'est pas reconnu
      common.default = [ "gtk" ];

      # Compositeurs basés sur wlroots
      sway.default     = [ "wlr" "gtk" ];
      river.default    = [ "wlr" "gtk" ];
      # dwl ne définit pas XDG_CURRENT_DESKTOP automatiquement ;
      # cette entrée s'active si la session DWL exporte XDG_CURRENT_DESKTOP=dwl
      dwl.default      = [ "wlr" "gtk" ];
      Hyprland.default = [ "hyprland" "gtk" ];
      # Niri n'a pas de portail propre, le portail GNOME est recommandé
      niri.default     = [ "gnome" "gtk" ];

      # GNOME — GTK en secours pour l'interface d'accès
      GNOME = {
        default = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.Access" = [ "gtk" ];
      };
    };
  };

  security.pam.services.swaylock = {
    text = "auth include login";
  };
}
