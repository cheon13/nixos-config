#!/usr/bin/env bash
####################################
# nom : menu.sh
# Script pour le menu d'application
# de DWL
# ##################################

source ~/.config/dwl/theme.sh

bemenu-run --prompt "Lancer" -i -W 0.3 -c -l 20 \
  --fn "${font} ${size}" \
  --ff $foreground  \
  --nf $primary   \
  --tb $primary     \
  --tf $on_primary  \
  --hf $foreground     \
  --af $primary  \
