#/bin/sh

swayidle -w\
    		timeout 300 'swaylock -f' \
    		timeout 600 ' wlopm --off eDP-1 --off  HDMI-A-1' \
		    resume 'wlopm --on eDP-1 --on  HDMI-A-1' \
    		before-sleep 'swaylock -f' &
