#!/bin/sh
####################################
# nom : menu.sh
# Script pour configurer le menu d'application
# utilisant wmenu-run
# de DWL
# ##################################

source $HOME/.config/dwl/theme.sh

wmenu-run -f "${font} ${size}" -S $bg
