# hyprland.nix 

{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.enable = true;

  wayland.windowManager.hyprland.settings = {
    exec-once = 
      [
        "waybar -c ~/.config/waybar/config.hyprland"
        "hyprpaper"
       ''swayidle -w timeout 300 'swaylock -f' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'swaylock -f' ''
        #"swaybg -i /home/cheon/Images/Wallpapers/hyprland.jpg"
      ];
    monitor = [
      "eDP-1, 1920x1080, 0x0,1"
      "HDMI-A-1, 1920x1080, 1920x0,1"
    ];
    env = [
      #"XCURSOR_SIZE,24"
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"
      "XDG_SESSION_DESKTOP,Hyprland"
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
   
    decoration = {
        rounding = "10";
        
        blur = {
            enabled = "false";
            #enabled = "true";
            size = "3";
            passes = "1";
        };
    
        drop_shadow = "yes";
        shadow_range = "4";
        shadow_render_power = "3";
        "col.shadow" = "rgba(1a1a1aee)";
    };

    animations = {
        enabled = "no";
        #enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = 
	  [
	    "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
	  ];  
    };

    # -----Bindings------
    "$mod" = "ALT";
    "$mod2" = "MOD5";
    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = 
      [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    bind =
      [
        "$mod, Return, exec, kitty"
        "$mod, W, exec, firefox"
        "$mod SHIFT, Q, killactive,"
        #"$mod SHIFT, E, exit,"
        "$mod SHIFT, E, exec,/home/cheon/.config/hypr/scripts/power-menu.sh"
        "$mod, V, togglefloating,"
        "$mod, D, exec, wofi --show drun"
        "$mod, N, exec, kitty nvim  +/Inbox /home/cheon/Documents/Cerveau/index.md"
        "$mod2, Return, exec, kitty"
        "$mod2, W, exec, firefox"
        "$mod2 SHIFT, Q, killactive,"
        #"$mod2 SHIFT, E, exit,"
        "$mod2 SHIFT, E, exec,/home/cheon/.config/hypr/scripts/power-menu.sh"
        "$mod2, V, togglefloating,"
        "$mod2, D, exec, wofi --show drun"
        "$mod2, N, exec, kitty nvim  +/Inbox /home/cheon/Documents/Cerveau/index.md"

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
        "$mod, f1, workspace, 1"
        "$mod, f2, workspace, 2"
        "$mod, f3, workspace, 3"
        "$mod, f4, workspace, 4"
        "$mod, f5, workspace, 5"
        "$mod, f6, workspace, 6"
        "$mod, f7, workspace, 7"
        "$mod, f8, workspace, 8"
        "$mod, f9, workspace, 9"
        "$mod, f10, workspace, 10"
        "$mod2, f1, workspace, 1"
        "$mod2, f2, workspace, 2"
        "$mod2, f3, workspace, 3"
        "$mod2, f4, workspace, 4"
        "$mod2, f5, workspace, 5"
        "$mod2, f6, workspace, 6"
        "$mod2, f7, workspace, 7"
        "$mod2, f8, workspace, 8"
        "$mod2, f9, workspace, 9"
        "$mod2, f10, workspace, 10"
        
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
        "$mod SHIFT, f1, movetoworkspace, 1"
        "$mod SHIFT, f2, movetoworkspace, 2"
        "$mod SHIFT, f3, movetoworkspace, 3"
        "$mod SHIFT, f4, movetoworkspace, 4"
        "$mod SHIFT, f5, movetoworkspace, 5"
        "$mod SHIFT, f6, movetoworkspace, 6"
        "$mod SHIFT, f7, movetoworkspace, 7"
        "$mod SHIFT, f8, movetoworkspace, 8"
        "$mod SHIFT, f9, movetoworkspace, 9"
        "$mod SHIFT, f10, movetoworkspace, 10"
        "$mod2 SHIFT, f1, movetoworkspace, 1"
        "$mod2 SHIFT, f2, movetoworkspace, 2"
        "$mod2 SHIFT, f3, movetoworkspace, 3"
        "$mod2 SHIFT, f4, movetoworkspace, 4"
        "$mod2 SHIFT, f5, movetoworkspace, 5"
        "$mod2 SHIFT, f6, movetoworkspace, 6"
        "$mod2 SHIFT, f7, movetoworkspace, 7"
        "$mod2 SHIFT, f8, movetoworkspace, 8"
        "$mod2 SHIFT, f9, movetoworkspace, 9"
        "$mod2 SHIFT, f10, movetoworkspace, 10"
        ", XF86AudioLowerVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioRaiseVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioMute,         exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute,      exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", Print, exec, slurp | grim -g -"
        "MOD4 SHIFT, S, exec, slurp | grim -g -"
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

  xdg.configFile."hypr/scripts/power-menu.sh".text = ''
#!/bin/sh
entries="Logout Suspend Reboot Shutdown"
selected=$(printf '%s\n' $entries | wofi --show=dmenu | awk '{print tolower($1)}')
case $selected in
  logout)
    hyprctl dispatch exit;;
  suspend)
    exec systemctl suspend;;
  reboot)
    exec systemctl reboot;;
  shutdown)
    exec systemctl poweroff -i;;
esac
  '';
  xdg.configFile."hypr/scripts/power-menu.sh".executable = true;
}
