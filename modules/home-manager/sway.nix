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
      defaultWorkspace = "workspace number 1";
      window.titlebar = false;
      modifier = "Mod1";
      keybindings  = let modifier1 = "Mod1"; modifier2 = "Mod5";
      in pkgs.lib.mkOptionDefault {
        "${modifier1}+t" = "layout tabbed";
        "${modifier2}+t" = "layout tabbed";
        "${modifier1}+w" = "exec firefox";
        "${modifier2}+w" = "exec firefox";
	"${modifier1}+Shift+q" = "kill";
	"${modifier2}+Shift+q" = "kill";
	"${modifier2}+d" = "exec menu";
	"${modifier1}+Shift+d" = "kill";
	"${modifier2}+Shift+d" = "kill";
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

        "${modifier1}+f1" = "workspace number 1";
        "${modifier1}+f2" = "workspace number 2";
        "${modifier1}+f3" = "workspace number 3";
        "${modifier1}+f4" = "workspace number 4";
        "${modifier1}+f5" = "workspace number 5";
        "${modifier1}+f6" = "workspace number 6";
        "${modifier1}+f7" = "workspace number 7";
        "${modifier1}+f8" = "workspace number 8";
        "${modifier1}+f9" = "workspace number 9";
        "${modifier1}+f10" = "workspace number 10";
        "${modifier2}+f1" = "workspace number 1";
        "${modifier2}+f2" = "workspace number 2";
        "${modifier2}+f3" = "workspace number 3";
        "${modifier2}+f4" = "workspace number 4";
        "${modifier2}+f5" = "workspace number 5";
        "${modifier2}+f6" = "workspace number 6";
        "${modifier2}+f7" = "workspace number 7";
        "${modifier2}+f8" = "workspace number 8";
        "${modifier2}+f9" = "workspace number 9";
        "${modifier2}+f10" = "workspace number 10";
	  
	"${modifier1}+Shift+f1" =
          "move container to workspace number 1";
        "${modifier1}+Shift+f2" =
          "move container to workspace number 2";
        "${modifier1}+Shift+f3" =
          "move container to workspace number 3";
        "${modifier1}+Shift+f4" =
          "move container to workspace number 4";
        "${modifier1}+Shift+f5" =
          "move container to workspace number 5";
        "${modifier1}+Shift+f6" =
          "move container to workspace number 6";
        "${modifier1}+Shift+f7" =
          "move container to workspace number 7";
        "${modifier1}+Shift+f8" =
          "move container to workspace number 8";
        "${modifier1}+Shift+f9" =
          "move container to workspace number 9";
        "${modifier1}+Shift+f10" =
          "move container to workspace number 10";

	"${modifier2}+Shift+f1" =
          "move container to workspace number 1";
        "${modifier2}+Shift+f2" =
          "move container to workspace number 2";
        "${modifier2}+Shift+f3" =
          "move container to workspace number 3";
        "${modifier2}+Shift+f4" =
          "move container to workspace number 4";
        "${modifier2}+Shift+f5" =
          "move container to workspace number 5";
        "${modifier2}+Shift+f6" =
          "move container to workspace number 6";
        "${modifier2}+Shift+f7" =
          "move container to workspace number 7";
        "${modifier2}+Shift+f8" =
          "move container to workspace number 8";
        "${modifier2}+Shift+f9" =
          "move container to workspace number 9";
        "${modifier2}+Shift+f10" =
          "move container to workspace number 10";

        "${modifier1}+Shift+c" = "reload";
        "${modifier2}+Shift+c" = "reload";
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
