#/bin/sh

# Script pour un menu de gestion réseau avec waybar
choix=$(printf "activer mode avion\ndesactiver mode avion\nconnecter a un reseau wifi\nnetwork manager applet" | tofi --prompt-text "Réseau")

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
