#!/usr/bin/env bash

# Script pour un menu pour se connecter à un réseau wifi

source ~/.config/waybar/matugen/bemenu-colors.sh

export BEMENU_OPTS="-i -W 0.3 -c -l 20 --fn JetBrainsMono 14 --fb $background --ff $foreground --nb $background --nf $foreground --tb $primary --hb $background --tf $on_primary --hf $primary  --af $foreground --ab $background -B 0 --bdr $foreground"

ssid=$(nmcli -f SSID device wifi | bemenu --prompt "Choisir le réseau" |sed 's/[[:blank:]]*$//' )
#echo "->$ssid<-"
networkpassword=$(echo "entrez un mot de passe" | bemenu --password indicator)
#echo "->$networkpassword<-"
nmcli dev wifi connect "$ssid" password "$networkpassword"
