#!/usr/bin/env bash
####################################
#
# Script pour la mise à jour
# mensuelle de NixOS
#
# ##################################

cd ~/.dotfiles

echo " -------------------- "
echo " mise à jour du flake "
echo " -------------------- "

nix flake update

echo " ----------------------- "
echo " reconstruire le système "
echo " ----------------------- "

sudo nixos-rebuild switch --flake ~/.dotfiles

echo " -------------------- "
echo " Nettoyage du système "
echo " -------------------- "

sudo nix-collect-garbage --delete-older-than 7d

echo " --------------------- "
echo " Optimise le nix store "
echo " --------------------- "

nix-store --optimise
