#!/usr/bin/env bash

source ~/.config/river/matugen/bemenu-colors.sh

# Script pour un menu de gestion réseau avec waybar
export BEMENU_OPTS="-i -W 0.3 -c -l 20 --fn JetBrainsMono 14 --fb $background --ff $foreground --nb $background --nf $foreground --tb $primary --hb $background --tf $on_primary --hf $primary  --af $foreground --ab $background -B 0 --bdr $foreground"

choix=$(printf "activer mode avion\ndesactiver mode avion\nconnecter a un reseau wifi\nnetwork manager" | bemenu --prompt "Réseau")

case $choix in
  "activer mode avion")
    nmcli radio wifi on && notify-send "wifi" "activé";;
  "desactiver mode avion")
    nmcli radio wifi off && notify-send "wifi" "désactivé";;
  "connecter a un reseau wifi")
    nm-connection-editor &;;
    #~/.config/waybar/scripts/connect-wifi.sh
  "network manager")
    foot nmtui &;;
esac
