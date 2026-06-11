#!/usr/bin/env bash
####################################
# nom : screenshot.sh
# Script pour prendre des copies-écrans
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

export GRIM_DEFAULT_DIR="/home/cheon/Images/Screenshots"

choix=$(printf "selection\necran" | bemenu --prompt "Copie d'écran")

case $choix in
  "selection")
    slurp | grim -g -&;;
  "ecran")
    grim &;;
esac
