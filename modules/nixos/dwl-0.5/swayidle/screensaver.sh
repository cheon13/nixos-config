#!/bin/sh
####################################
# nom : screensaver.sh
# Script pour configurer le screensaver
# de DWL
# ##################################
swayidle -w\
    timeout 1070 'swaylock -f -C ~/.config/swaylock/config'\
    timeout 770 'wlr-randr  --output eDP-1  --off --output HDMI-A-1 --off' \
    resume 'wlr-randr  --output eDP-1  --on --output HDMI-A-1 --on' \
    before-sleep 'swaylock -C ~/.config/swaylock/config' &
