# Module Emacs (config « vanilla » literate)
#
# La config réelle vit dans modules/home-manager/config/emacs/ :
#   - init.el   : bootstrap qui tangle config.org -> config.el puis le charge
#   - config.org: config literate (le seul fichier réellement édité)
#
# On lie ces deux fichiers dans ~/.config/emacs via des symlinks
# « out-of-store » : ils pointent directement vers le dépôt ~/.dotfiles,
# donc éditer config.org ne nécessite PAS de relancer `home-manager switch`
# (seulement si on ajoute ou retire un fichier ici).
#
# Le reste de ~/.config/emacs (config.el généré, elpa/, eln-cache/, backups…)
# reste un vrai dossier hors dépôt : Emacs y écrit ses fichiers d'exécution
# et télécharge les paquets depuis MELPA/ELPA au premier lancement.

{ config, pkgs, ... }:

let
  # Chemin absolu vers les sources dans le dépôt (hors /nix/store).
  emacsSrc = "${config.home.homeDirectory}/.dotfiles/modules/home-manager/config/emacs";
in
{
  # Build native Wayland (pgtk) — cf. environnement dwl du portable.
  home.packages = [ pkgs.emacs-pgtk ];

  # Symlinks out-of-store fichier par fichier.
  home.file.".config/emacs/init.el".source =
    config.lib.file.mkOutOfStoreSymlink "${emacsSrc}/init.el";
  home.file.".config/emacs/config.org".source =
    config.lib.file.mkOutOfStoreSymlink "${emacsSrc}/config.org";
}
