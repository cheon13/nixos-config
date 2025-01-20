{ config, ... }:

{

  wayland.windowManager.river = {
    enable = true;
    systemd.enable = true;
    extraConfig = ''
      #!/bin/sh

      # This is the example configuration file for river.
      #
      # If you wish to edit this, you will probably want to copy it to
      # $XDG_CONFIG_HOME/river/init or $HOME/.config/river/init first.
      #
      # See the river(1), riverctl(1), and rivertile(1) man pages for complete
      # documentation.

      # Note: the "Alt" modifier is also known as Logo, GUI, Windows, Mod4, etc.
      #       the "Alt-char" modifier is Mod5

      # Alt+Return to start an instance of kitty terminal
      riverctl map normal Alt Return spawn kitty

      # Alt+W to start an instance of firefox
      riverctl map normal Alt W spawn firefox
      riverctl map normal Mod5 W spawn firefox

      # Alt-N Pour prendre des notes rapidement
      riverctl map normal Alt N spawn 'kitty -d ~/Documents/Cerveau nvim +/Note /home/cheon/Documents/Cerveau/index.md'

      # Alt-Shift S Pour prendre des notes rapidement
      riverctl map normal Alt+Shift S spawn 'slurp | grim -g -'
      riverctl map normal Mod5+Shift S spawn 'slurp | grim -g -'

      # Mapping pour le menu wofi 
      riverctl map normal Alt D spawn 'wofi --show drun'
      riverctl map normal Mod5 D spawn 'wofi --show drun'

      # Alt+Q to close the focused view
      riverctl map normal Alt+Shift Q close
      riverctl map normal Mod5+Shift Q close

      # Alt+Shift+E to exit river
      riverctl map normal Alt+Shift E exit
      riverctl map normal Mod5+Shift E exit

      # Alt+J and Alt+K to focus the next/previous view in the layout stack
      riverctl map normal Alt J focus-view next
      riverctl map normal Alt K focus-view previous

      # Alt+Shift+J and Alt+Shift+K to swap the focused view with the next/previous
      # view in the layout stack
      riverctl map normal Alt+Shift J swap next
      riverctl map normal Alt K focus-view previous
      riverctl map normal Alt+Shift K swap previous
      riverctl map normal Alt K focus-view previous

      # Alt+Period and Alt+Comma to focus the next/previous output
      riverctl map normal Alt Period focus-output next
      riverctl map normal Alt K focus-view previous
      riverctl map normal Alt Comma focus-output previous
      riverctl map normal Alt K focus-view previous

      # Alt+Shift+{Period,Comma} to send the focused view to the next/previous output
      riverctl map normal Alt+Shift Period send-to-output next
      riverctl map normal Alt K focus-view previous
      riverctl map normal Alt+Shift Comma send-to-output previous
      riverctl map normal Alt K focus-view previous

      # Alt+Shift+Return to bump the focused view to the top of the layout stack
      riverctl map normal Alt+Shift Return zoom
      riverctl map normal Alt+Shift K focus-view previous

      # Alt+H and Alt+L to decrease/increase the main ratio of rivertile(1)
      riverctl map normal Alt H send-layout-cmd rivertile "main-ratio -0.05"
      riverctl map normal Alt K focus-view previous
      riverctl map normal Alt L send-layout-cmd rivertile "main-ratio +0.05"
      riverctl map normal Alt K focus-view previous

      # Alt+Shift+H and Alt+Shift+L to increment/decrement the main count of rivertile(1)
      riverctl map normal Alt+Shift H send-layout-cmd rivertile "main-count +1"
      riverctl map normal Alt K focus-view previous
      riverctl map normal Alt+Shift L send-layout-cmd rivertile "main-count -1"

      # Super+Alt+{H,J,K,L} to move views
      riverctl map normal Super+Alt H move left 100
      riverctl map normal Super+Alt J move down 100
      riverctl map normal Super+Alt K move up 100
      riverctl map normal Super+Alt L move right 100

      # Super+Alt+Control+{H,J,K,L} to snap views to screen edges
      riverctl map normal Super+Alt+Control H snap left
      riverctl map normal Super+Alt+Control J snap down
      riverctl map normal Super+Alt+Control K snap up
      riverctl map normal Super+Alt+Control L snap right

      # Super+Alt+Shift+{H,J,K,L} to resize views
      riverctl map normal Super+Alt+Shift H resize horizontal -100
      riverctl map normal Super+Alt+Shift J resize vertical 100
      riverctl map normal Super+Alt+Shift K resize vertical -100
      riverctl map normal Super+Alt+Shift L resize horizontal 100

      # Alt + Left Mouse Button to move views
      riverctl map-pointer normal Alt BTN_LEFT move-view

      # Alt + Right Mouse Button to resize views
      riverctl map-pointer normal Alt BTN_RIGHT resize-view

      # Alt + Middle Mouse Button to toggle float
      riverctl map-pointer normal Alt BTN_MIDDLE toggle-float

      #for i in $(seq 1 9)
      for i in $(seq 1 5)
      do
          tags=$((1 << ($i - 1)))
      
          # Alt+[1-9] to focus tag [0-8]
          riverctl map normal Alt $i set-focused-tags $tags
          riverctl map normal Alt F$i set-focused-tags $tags
          riverctl map normal Mod5 F$i set-focused-tags $tags
      
          # Alt+Shift+[1-9] to tag focused view with tag [0-8]
          riverctl map normal Alt+Shift $i set-view-tags $tags
          riverctl map normal Alt+Shift F$i set-view-tags $tags
          riverctl map normal Mod5+Shift F$i set-view-tags $tags
      
          # Alt+Control+[1-9] to toggle focus of tag [0-8]
          riverctl map normal Alt+Control $i toggle-focused-tags $tags
          riverctl map normal Alt+Control F$i toggle-focused-tags $tags
          riverctl map normal Mod5+Control F$i toggle-focused-tags $tags
      
          # Alt+Shift+Control+[1-9] to toggle tag [0-8] of focused view
          riverctl map normal Alt+Shift+Control $i toggle-view-tags $tags
          riverctl map normal Alt+Shift+Control F$i toggle-view-tags $tags
          riverctl map normal Mod5+Shift+Control F$i toggle-view-tags $tags
      done

      # Alt+0 to focus all tags
      # Alt+Shift+0 to tag focused view with all tags
      all_tags=$(((1 << 32) - 1))
      riverctl map normal Alt 0 set-focused-tags $all_tags
      riverctl map normal Alt+Shift 0 set-view-tags $all_tags

      # Alt+Space to toggle float
      riverctl map normal Alt Space toggle-float

      # Alt+F to toggle fullscreen
      riverctl map normal Alt F toggle-fullscreen
      riverctl map normal Mod5 F toggle-fullscreen

      # Alt+{Up,Right,Down,Left} to change layout orientation
      riverctl map normal Alt Up    send-layout-cmd rivertile "main-location top"
      riverctl map normal Alt Right send-layout-cmd rivertile "main-location right"
      riverctl map normal Alt Down  send-layout-cmd rivertile "main-location bottom"
      riverctl map normal Alt Left  send-layout-cmd rivertile "main-location left"

      # Declare a passthrough mode. This mode has only a single mapping to return to
      # normal mode. This makes it useful for testing a nested wayland compositor
      riverctl declare-mode passthrough

      # Alt+F11 to enter passthrough mode
      riverctl map normal Alt F11 enter-mode passthrough

      # Alt+F11 to return to normal mode
      riverctl map passthrough Alt F11 enter-mode normal

      # Various media key mapping examples for both normal and locked mode which do
      # not have a modifier
      for mode in normal locked
      do
          # Control pulse audio volume with pamixer (https://github.com/cdemoulins/pamixer)
          riverctl map $mode None XF86AudioRaiseVolume  spawn 'pactl set-sink-volume @DEFAULT_SINK@ +5% && $sink_volume'
          riverctl map $mode None XF86AudioLowerVolume  spawn 'pactl set-sink-volume @DEFAULT_SINK@ -5% && $sink_volume'
          riverctl map $mode None XF86AudioMute         spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle && pactl get-sink-mute @DEFAULT_SINK@ | sed -En '/no/ s/.*/$($sink_volume)/p; /yes/ s/.*/0/p'"
          riverctl map $mode None XF86AudioMicMute  spawn 'pactl set-source-mute @DEFAULT_SOURCE@ toggle'
          # Control screen backlight brightness with brightnessctl (https://github.com/Hummer12007/brightnessctl)
          riverctl map $mode None XF86MonBrightnessUp   spawn 'brightnessctl set +5%'
          riverctl map $mode None XF86MonBrightnessDown spawn 'brightnessctl set 5%-'
      done


      # Set background and border color
      #riverctl background-color 0x002b36
      #riverctl border-color-focused 0x93a1a1
      #riverctl border-color-unfocused 0x586e75

      riverctl border-color-focused 0xd4be98
      riverctl border-color-unfocused 0x92a58b
      riverctl border-width 2
      riverctl background-color 0x282828

      # Set keyboard repeat rate
      riverctl set-repeat 50 300

      # Configurer le layout du clavier
      riverctl keyboard-layout ca

      # Make all views with an app-id that starts with "float" and title "foo" start floating.
      riverctl rule-add -app-id 'float*' -title 'foo' float

      # Make all views with app-id "bar" and any title use client-side decorations
      riverctl rule-add -app-id "bar" csd

      # Set the default layout generator to be rivertile and start it.
      # River will send the process group of the init executable SIGTERM on exit.
      riverctl default-layout rivertile
      rivertile -view-padding 6 -outer-padding 6 &

      # Ajout des fonds d'écran
      swaybg -i /home/cheon/Images/Wallpapers/riverWP &
      # Ajout de la barre
      waybar -c ~/.config/waybar/river.config -s ~/.config/waybar/river.style.css &
      # Ajout du screen saver et du lock screen
      swayidle -w\
          		timeout 300 'swaylock -f' \
          		timeout 600 ' wlopm --off eDP-1 --off  HDMI-A-1' \
      		    resume 'wlopm --on eDP-1 --on  HDMI-A-1' \
          		before-sleep 'swaylock -f' &
    '';
  };
}
