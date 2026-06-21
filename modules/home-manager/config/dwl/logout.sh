#!/usr/bin/env bash
####################################
# nom : energie.sh
# Script pour le menu de contrôle de session
# de DWL
# ##################################

source ~/.config/dwl/theme.sh
fontsize="${font} ${size}"

choix=$(printf "oui\nnon" | bemenu --prompt "Voulez-vous fermer la session")

case $choix in
  "oui")
    pkill dwl&;;
  "non")
    ;;
esac
