#!/bin/sh
source $HOME/.config/dwl/theme.sh

# Propager les variables Wayland au bus D-Bus et aux services systemd utilisateur
# Nécessaire pour xdg-desktop-portal-wlr et autres services qui en dépendent
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY

export MOZ_ENABLE_WAYLAND=1
firefox &
swaybg -i ~/Images/Wallpapers/$wallpaper &
~/.config/dwl/screensaver.sh &
dwlb -font "${font}:size=${size}" -center-title -active-bg-color $bg -occupied-bg-color $bg -middle-bg-color-selected $bg -inactive-fg-color $inactiveFg
