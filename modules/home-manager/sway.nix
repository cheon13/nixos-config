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
	
        "${modifier2}+b" = "splith";
        "${modifier2}+v" = "splitv";
        "${modifier2}+f" = "fullscreen toggle";
        "${modifier2}+a" = "focus parent";

        "${modifier2}+s" = "layout stacking";
        "${modifier2}+e" = "layout toggle split";

        "${modifier2}+Shift+space" = "floating toggle";
        "${modifier2}+space" = "focus mode_toggle";

        "${modifier2}+f1" = "workspace number 1";
        "${modifier2}+f2" = "workspace number 2";
        "${modifier2}+f3" = "workspace number 3";
        "${modifier2}+f4" = "workspace number 4";
        "${modifier2}+f5" = "workspace number 5";
        "${modifier2}+f6" = "workspace number 6";
        "${modifier2}+f7" = "workspace number 7";
        "${modifier2}+f8" = "workspace number 8";
        "${modifier2}+f9" = "workspace number 9";
        "${modifier2}+f0" = "workspace number 10";
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
