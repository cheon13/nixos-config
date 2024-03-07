# hyprland.nix 

{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.enable = true;

  wayland.windowManager.hyprland.settings = {
    exec-once = 
      [
        "waybar -c ~/.config/waybar/config.hyprland"
        "swaybg -i /home/cheon/Images/Wallpapers/hyprland.jpg"
      ];
  
    input = {
        kb_layout = "ca";
        #kb_variant =
        #kb_model =
        #kb_options = 
        #kb_rules =
    
        follow_mouse = "1";
        sensitivity = "0"; # -1.0 - 1.0, 0 means no modification.
    };

    general = {
       gaps_in = "5";
       gaps_out = "20";
       border_size = "2";
       "col.active_border" = "rgba(8ec07cee)";
       "col.inactive_border" = "rgba(595959aa)";
       layout = "dwindle";
       allow_tearing = "false";
    };
   
    "$mod" = "SUPER";
    bind =
      [
        "$mod, Return, exec, kitty"
        "$mod, W, exec, firefox"
	"$mod SHIFT, Q, killactive,"
	"$mod SHIFT, E, exit,"
	"$mod, V, togglefloating,"
	"$mod, D, exec, wofi --show drun"

        # Move focus with mainMod + arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        
        # Move focus with mainMod + hlkj
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        
        # Move window
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"
        
        # Switch workspaces with mainMod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        
        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        #", Print, exec, grimblast copy area"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );
  };
}
