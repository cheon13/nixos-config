# Module Emacs (config « vanilla »)
#
# La config réelle vit dans modules/home-manager/config/emacs/init.el.
#
# On lie ce fichier dans ~/.config/emacs via un symlink « out-of-store » :
# il pointe directement vers le dépôt ~/.dotfiles, donc éditer init.el ne
# nécessite PAS de relancer `home-manager switch`.
#
# Le reste de ~/.config/emacs (elpa/, eln-cache/, backups…) reste un vrai
# dossier hors dépôt : Emacs y écrit ses fichiers d'exécution et télécharge
# les paquets depuis MELPA/ELPA au premier lancement.

{ config, pkgs, ... }:

let
  # Chemin absolu vers les sources dans le dépôt (hors /nix/store).
  emacsSrc = "${config.home.homeDirectory}/.dotfiles/modules/home-manager/config/emacs";
in
{
  # Build native Wayland (pgtk) — cf. environnement dwl du portable.
  home.packages = [ pkgs.emacs-pgtk ];

  # Symlink out-of-store.
  home.file.".config/emacs/init.el".source =
    config.lib.file.mkOutOfStoreSymlink "${emacsSrc}/init.el";
}
