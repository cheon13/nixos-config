{ config, ... }:

{

  wayland.windowManager.river = {
    enable = true;
    systemd.enable = true;
    extraConfig = ''
      #!/bin/sh

      # See the river(1), riverctl(1), and rivertile(1) man pages for complete
      # documentation.

      # Note: the "Alt" modifier is also known as Logo, GUI, Windows, Mod4, etc.
      #       the "Alt-char" modifier is Mod5

      # Alt+Return to start an instance of wezterm terminal
      #riverctl map normal Alt Return spawn wezterm

      # Alt+Return to start an instance of foot terminal
      riverctl map normal Alt Return spawn foot
      riverctl map normal Alt T spawn foot

      # Alt+W to start an instance of firefox
      riverctl map normal Alt R spawn firefox
      #riverctl map normal Mod5 W spawn firefox

      # Alt+N Pour prendre des notes rapidement
      #riverctl map normal Alt N spawn 'kitty -d ~/Documents/Cerveau nvim +/Note /home/cheon/Documents/Cerveau/index.md'
      riverctl map normal Alt I spawn 'foot -T Notes -D ~/Documents/Cerveau nvim +/Note /home/cheon/Documents/Cerveau/index.md'
      #riverctl map normal Alt N spawn 'wezterm start  --cwd  ~/Documents/Cerveau nvim +/Note /home/cheon/Documents/Cerveau/index.md'

      # Alt+Shift S Pour prendre copie-écran
      riverctl map normal Alt+Shift T spawn 'slurp | grim -g -'
      riverctl map normal Mod5+Shift S spawn 'slurp | grim -g -'

      # Alt P Pour afficher passmenu pour passwordstore
      riverctl map normal Alt Y spawn '~/.config/river/scripts/passmenu.sh'
      #riverctl map normal Mod5 P spawn 'passmenu'

      # Mapping pour le menu wofi 
      #riverctl map normal Alt D spawn 'wofi --show drun'
      #riverctl map normal Mod5 D spawn 'wofi --show drun'

      # Mapping pour le menu bemenu-run
      riverctl map normal Alt D spawn '~/.config/river/scripts/menu-run.sh' 
      #riverctl map normal Mod5 D spawn 'bemenu-run --prompt "Lancer" -i -W 0.3 -c -l 20 --fn JetBrainsMono 14 --fb "#282828" --ff "#ebdbb2" --nb "#282828" --nf "#ebdbb2" --tb "#282828" --hb "#282828" --tf "#fb4934" --hf "#fabd2f"  --af "#ebdbb2" --ab "#282828" -B 2 --bdr "#ebdbb2"'

      # Mapping pour le menu réseau 
      #riverctl map normal Alt R spawn '~/.config/waybar/scripts/reseau.sh'
      #riverctl map normal Mod5 R spawn '~/.config/waybar/scripts/reseau.sh'

      # Alt+Q to close the focused view
      riverctl map normal Alt+Shift Q close
      riverctl map normal Mod5+Shift Q close

      # Alt+Shift+E to exit river
      riverctl map normal Alt+Shift E exit
      riverctl map normal Mod5+Shift E exit

      # Alt+J and Alt+K to focus the next/previous view in the layout stack
      riverctl map normal Alt H focus-view left
      riverctl map normal Alt J focus-view down
      riverctl map normal Alt K focus-view up
      riverctl map normal Alt L focus-view right

      # Ergol Mod4+J and Mod4+K to focus the next/previous view in the layout stack
      riverctl map normal Mod4 L focus-view left
      riverctl map normal Mod4 R focus-view down
      riverctl map normal Mod4 T focus-view up
      riverctl map normal Mod4 I focus-view right

      # Alt+Shift+J and Alt+Shift+K to swap the focused view with the next/previous
      # view in the layout stack
      riverctl map normal Alt+Shift J swap next
      riverctl map normal Alt+Shift K swap previous
      riverctl map normal Mod4+Shift R swap next
      riverctl map normal Mod4+Shift T swap previous

      # Alt+Period and Alt+Comma to focus the next/previous output
      riverctl map normal Alt Period focus-output next
      riverctl map normal Alt Comma focus-output previous

      # Ergol Mod4+D and Mod4+M to focus the next/previous output
      riverctl map normal Mod4 D focus-output next
      riverctl map normal Mod4 M focus-output previous

      # Ergol Mod4+H to focus the previous tag
      riverctl map normal Mod4 Period focus-previous-tags

      # Alt+Shift+{Period,Comma} to send the focused view to the next/previous output
      riverctl map normal Alt+Shift Period send-to-output next
      riverctl map normal Alt+Shift Comma send-to-output previous

      # Ergol Mod4+Shift+{Period,Comma} to send the focused view to the next/previous output
      riverctl map normal Mod4+Shift D send-to-output next
      riverctl map normal Mod4+Shift M send-to-output previous

      # Alt+Shift+Return to bump the focused view to the top of the layout stack
      riverctl map normal Alt+Shift Return zoom
      riverctl map normal Mod4+Shift Return zoom

      # Alt+H and Alt+L to decrease/increase the main ratio of rivertile(1)
      riverctl map normal Alt+Shift H send-layout-cmd rivertile "main-ratio -0.05"
      riverctl map normal Alt+Shift L send-layout-cmd rivertile "main-ratio +0.05"
      riverctl map normal Mod4+Shift L send-layout-cmd rivertile "main-ratio -0.05"
      riverctl map normal Mod4+Shift I send-layout-cmd rivertile "main-ratio +0.05"

      # Alt+Shift+H and Alt+Shift+L to increment/decrement the main count of rivertile(1)
      #riverctl map normal Alt+Shift H send-layout-cmd rivertile "main-count +1"
      #riverctl map normal Alt+Shift L send-layout-cmd rivertile "main-count -1"

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
          riverctl map normal Mod4 $i set-focused-tags $tags

          # Alt+Shift+[1-9] to tag focused view with tag [0-8]
          riverctl map normal Alt+Shift $i set-view-tags $tags
          riverctl map normal Alt+Shift F$i set-view-tags $tags
          riverctl map normal Mod5+Shift F$i set-view-tags $tags
          riverctl map normal Mod4+Shift $i set-view-tags $tags

          # Alt+Control+[1-9] to toggle focus of tag [0-8]
          riverctl map normal Alt+Control $i toggle-focused-tags $tags
          riverctl map normal Alt+Control F$i toggle-focused-tags $tags
          riverctl map normal Mod5+Control F$i toggle-focused-tags $tags
          riverctl map normal Mod4+Control $i toggle-focused-tags $tags

          # Alt+Shift+Control+[1-9] to toggle tag [0-8] of focused view
          riverctl map normal Alt+Shift+Control $i toggle-view-tags $tags
          riverctl map normal Alt+Shift+Control F$i toggle-view-tags $tags
          riverctl map normal Mod5+Shift+Control F$i toggle-view-tags $tags
          riverctl map normal Mod4+Shift+Control $i toggle-view-tags $tags
      done

      # Ergol map tags 1,2,3,4 to h g , k
      riverctl map normal Mod4 H set-focused-tags $((1 << (1 - 1)))
      riverctl map normal Mod4 G set-focused-tags $((1 << (2 - 1)))
      riverctl map normal Mod4 Comma set-focused-tags $((1 << (3 - 1)))
      riverctl map normal Mod4 K set-focused-tags $((1 << (4 - 1)))

      riverctl map normal Mod4+Shift H set-view-tags $((1 << (1 - 1)))
      riverctl map normal Mod4+Shift G set-view-tags $((1 << (2 - 1)))
      riverctl map normal Mod4+Shift Comma set-view-tags $((1 << (3 - 1)))
      riverctl map normal Mod4+Shift K set-view-tags $((1 << (4 - 1)))


      # Alt+0 to focus all tags
      # Alt+Shift+0 to tag focused view with all tags
      all_tags=$(((1 << 32) - 1))
      riverctl map normal Alt 0 set-focused-tags $all_tags
      riverctl map normal Alt+Shift 0 set-view-tags $all_tags

      # Alt+Space to toggle float
      riverctl map normal Alt Space toggle-float
      riverctl map normal Mod4 Space toggle-float

      # Alt+F to toggle fullscreen
      riverctl map normal Alt F toggle-fullscreen
      riverctl map normal Mod4 F toggle-fullscreen

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
      riverctl keyboard-layout -model pc101 -variant ergol fr
      #riverctl keyboard-layout ca

      # Make all views with an app-id that starts with "float" and title "foo" start floating.
      riverctl rule-add -app-id 'float*' -title 'foo' float

      # Make all views with app-id "bar" and any title use client-side decorations
      riverctl rule-add -app-id "bar" csd

      # Set the default layout generator to be rivertile and start it.
      # River will send the process group of the init executable SIGTERM on exit.
      riverctl default-layout rivertile
      rivertile -view-padding 6 -outer-padding 6 &

      # Ajout des fonds d'écran
      riverctl spawn "swaybg -i /home/cheon/Images/Wallpapers/riverWP"
      # Ajout de la barre
      riverctl spawn "waybar -c ~/.config/waybar/river.config -s ~/.config/waybar/river.style.css"
      # Ajout du screen saver et du lock screen
      riverctl spawn "swayidle -w\
          		timeout 300 'swaylock -f' \
          		timeout 600 ' wlopm --off eDP-1 --off  HDMI-A-1' \
      		    resume 'wlopm --on eDP-1 --on  HDMI-A-1' \
          		before-sleep 'swaylock -f'"
    '';
  };
}
