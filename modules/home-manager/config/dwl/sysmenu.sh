#!/usr/bin/env bash
####################################
# nom : sysmenu.sh
# Script pour le menu système
# de DWL
# ##################################

source ~/.config/dwl/theme.sh

choix=$(printf "son\nreseau\ncopie-ecran\necran-de-veille\nenergie\nsession" | bemenu --prompt "Menu système")

case $choix in
  "son")
    pavucontrol&;;
  "reseau")
    foot nmtui &;;
  "copie-ecran")
    ~/.config/dwl/screenshot.sh&;;
  "ecran-de-veille")
    ~/.config/dwl/menu-screensaver.sh&;;
  "energie")
    ~/.config/dwl/energie.sh &;;
  "session")
    ~/.config/dwl/session.sh &;;
esac
