#!/usr/bin/env bash
####################################
# nom : energie.sh
# Script pour le menu de contrôle des modes de performance
# de DWL. Utilise le daemon de gnome powerprofiles
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

choix=$(printf "performance\nequilibre\neconomie" | bemenu --prompt "Énergie: profils de performance")

case $choix in
  "performance")
    powerprofilesctl set performance&;;
  "equilibre")
    powerprofilesctl set balanced&;;
  "economie")
    powerprofilesctl set power-saver&;;
esac
