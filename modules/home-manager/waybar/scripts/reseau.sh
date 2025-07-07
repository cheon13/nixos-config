#!/usr/bin/env bash

source ~/.config/waybar/matugen/bemenu-colors.sh

bemenu-run --prompt "Lancer" -i -W 0.3 -c -l 20 --fn JetBrainsMono 14 --fb $background --ff $foreground --nb $background --nf $foreground --tb $primary --hb $background --tf $on_primary --hf $primary  --af $foreground --ab $background -B 0 --bdr $foreground

# Script pour un menu de gestion réseau avec waybar
export BEMENU_OPTS="-i -W 0.3 -c -l 20 --fn JetBrainsMono 14 --fb $background --ff '#ebdbb2' --nb '#282828' --nf '#ebdbb2' --tb '#282828' --hb '#282828' --tf '#fb4934' --hf '#fabd2f'  --af '#ebdbb2' --ab '#282828' -B 2 --bdr '#ebdbb2'"

choix=$(printf "activer mode avion\ndesactiver mode avion\nconnecter a un reseau wifi\nnetwork manager applet" | bemenu --prompt "Réseau")

case $choix in
  "activer mode avion")
    nmcli radio wifi on && notify-send "wifi" "activé";;
  "desactiver mode avion")
    nmcli radio wifi off && notify-send "wifi" "désactivé";;
  "connecter a un reseau wifi")
    nm-connection-editor &;;
    #~/.config/waybar/scripts/connect-wifi.sh
  "network manager applet")
    nm-applet &;;
esac
