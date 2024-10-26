# Shell script pour construire nouvelle configuration NixOS
#
if [[ -z $1 ]]; then
	echo "Ajouter un commentaire pour le commit"
	exit
fi
git add .
git commit -m $1
sudo nixos-rebuild switch --flake ~/.dotfiles
