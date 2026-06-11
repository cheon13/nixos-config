{ pkgs, ... }:

{
  hardware.graphics.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr      # compositeur wlroots : DWL
      xdg-desktop-portal-gtk      # fallback GTK pour les applications GTK
      xdg-desktop-portal-gnome    # GNOME
    ];
    config = {
      # Fallback si XDG_CURRENT_DESKTOP n'est pas reconnu
      common.default = [ "gtk" ];

      # Compositeur basé sur wlroots
      # dwl ne définit pas XDG_CURRENT_DESKTOP automatiquement ;
      # cette entrée s'active si la session DWL exporte XDG_CURRENT_DESKTOP=dwl
      dwl.default      = [ "wlr" "gtk" ];

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
