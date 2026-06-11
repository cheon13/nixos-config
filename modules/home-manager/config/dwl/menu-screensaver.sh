#!/usr/bin/env bash
####################################
# nom : sysmenu.sh
# Script pour le menu système
# de DWL
# ##################################

source ~/.config/dwl/theme.sh
fontsize="${font} ${size}"

export BEMENU_OPTS="-i -W 0.3 -c -l 20 \
  --fn $fontsize\
  --ff $foreground  \
  --nf $primary   \
  --tb $primary     \
  --tf $on_primary  \
  --hf $foreground     \
  --af $primary  "

choix=$(printf "activer\ndesactiver" | bemenu --prompt "Écran de veille")

case $choix in
  "activer")
    ~/.config/dwl/screensaver.sh&;;
  "desactiver")
    ~/.config/dwl/stop-screensaver.sh&;;
esac
