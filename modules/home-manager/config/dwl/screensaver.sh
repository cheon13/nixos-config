#!/bin/sh
####################################
# nom : screensaver.sh
# Script pour configurer le screensaver
# de DWL
# ##################################

source $HOME/.config/dwl/theme.sh

swayidle -w\
    		timeout 300 "swaylock -f -i ${HOME}/Images/Wallpapers/${wallpaper}" \
    		timeout 600 " wlopm --off eDP-1 --off  HDMI-A-1" \
		    resume "wlopm --on eDP-1 --on  HDMI-A-1" \
    		before-sleep "swaylock -f -i ${HOME}/Images/Wallpapers/${wallpaper}"&
