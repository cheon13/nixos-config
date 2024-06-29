{ config, pkgs, ... }:

{
  # Use sway desktop environment with Wayland display server
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    # Sway-specific Configuration
    config = {
      input = { 
        "*" = {
          xkb_layout = "ca";
          # xkb_variant = "";
          # xkb_Options = "caps:swapescape";
          };
      };
      window.titlebar = false;
      modifier = "Mod1";
      keybindings  = let modifier1 = "Mod1"; modifier2 = "Mod5";
      in pkgs.lib.mkOptionDefault {
        "${modifier1}+t" = "layout tabbed";
        "${modifier2}+t" = "layout tabbed";
        "${modifier1}+w" = "exec firefox";
        "${modifier2}+w" = "exec firefox";
        "${modifier1}+Shift+e" = "exec ~/.config/sway/scripts/power-menu.sh";
        "${modifier2}+Shift+e" = "exec ~/.config/sway/scripts/power-menu.sh";
        # "${modifier}+Shift+e" = "exec swaymsg exit";
        # "${modifier}+Shift+e" = "exec swaynag -t warning -m 'Voulez-vous vraiment quitter ?' -b 'Yes, exit sway' 'swaymsg exit'";
      };
      terminal = "kitty";
      menu = "wofi --show drun";
      # Status bar(s)
      bars = [{
        command = "waybar";
      }];
      # Display device configuration
      output = {
        eDP-1 = {
          # Set HIDP scale (pixel integer scaling)
          scale = "1";
            };
          };
     startup = [
       # Lancer l'application de fond d'écran au démarrage 
       {command = "swaybg -i /home/cheon/Images/Wallpapers/sway.png";}
       # Lancer swayidle et swaylock 
       {command = ''swayidle -w\
    		timeout 300 'swaylock -f' \
    		timeout 600 'swaymsg "output * dpms off"' \
		resume 'swaymsg "output * dpms on"' \
    		before-sleep 'swaylock -f' '';}
     ];
    };
    # End of Sway-specific Configuration
  };

}
