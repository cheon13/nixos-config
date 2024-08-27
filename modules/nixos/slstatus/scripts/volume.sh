#!/bin/sh
####################################
#
# Script pour obtenir le volume sonore en pourcentage
#
# ##################################
amixer get Master | tail -1 | sed 's/.*\[\([0-9]*%\)\].*/\1/'
