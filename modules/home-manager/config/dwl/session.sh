#!/usr/bin/env bash
####################################
# nom : energie.sh
# Script pour le menu de contrôle de session
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

choix=$(printf "deconnecte\nredemarre\neteindre" | bemenu --prompt "Menu session")

case $choix in
  "deconnecte")
    pkill dwl&;;
  "redemarre")
    systemctl reboot&;;
  "eteindre")
    systemctl poweroff&;;
esac
