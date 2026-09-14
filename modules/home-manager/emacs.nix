# Module Emacs (config « vanilla »)
#
# La config réelle vit dans modules/home-manager/config/emacs/init.el.
#
# On lie ce fichier dans ~/.config/emacs via un symlink « out-of-store » :
# il pointe directement vers le dépôt ~/.dotfiles, donc éditer init.el ne
# nécessite PAS de relancer `home-manager switch`.
#
# REVERS, qui se paie au déploiement distant : le lien vise le dépôt de LA
# MACHINE. `nixos-rebuild --target-host' copie la clôture système mais ne
# touche jamais à la copie de travail git de la cible, qui continue donc de
# lire son propre init.el, parfois vieux de plusieurs commits — sans la
# moindre erreur, puisque le fichier est valide. Après tout déploiement
# distant :
#
#   ssh -A cheon@<machine> git -C ~/.dotfiles pull
#   ssh cheon@<machine> systemctl --user restart emacs.service
#
# Le -A transmet l'agent SSH : les machines n'ont pas de clé pour GitHub.
#
# Le reste de ~/.config/emacs (elpa/, eln-cache/, backups…) reste un vrai
# dossier hors dépôt : Emacs y écrit ses fichiers d'exécution et télécharge
# les paquets depuis MELPA/ELPA au premier lancement.

{ config, pkgs, ... }:

let
  # Chemin absolu vers les sources dans le dépôt (hors /nix/store).
  emacsSrc = "${config.home.homeDirectory}/.dotfiles/modules/home-manager/config/emacs";

  # Cible du schéma « org-protocol:// » (capture depuis Firefox).
  #
  # Passer par un script plutôt que d'écrire la commande directement dans
  # Exec= évite les règles d'échappement des guillemets du format .desktop :
  # l'alist passée à -F en contient.
  #
  #   -c   crée une frame : le daemon peut très bien tourner sans frame
  #        visible, auquel cas le tampon de capture s'ouvrirait dans le vide.
  #   -F   nomme cette frame « org-capture » ; init.el la referme une fois
  #        la capture finalisée ou abandonnée.
  #   -a   chaîne vide = démarre le daemon s'il ne tourne pas encore.
  orgProtocolCapture = pkgs.writeShellScriptBin "org-protocol-capture" ''
    exec ${config.programs.emacs.finalPackage}/bin/emacsclient \
      -c -a "" -F '((name . "org-capture"))' -- "$1"
  '';
in
{
  # Build native Wayland (pgtk) — cf. environnement dwl du portable.
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;

    # Paquets Emacs fournis par Nix plutôt que par package.el/MELPA.
    # Réservé aux paquets qui embarquent du code natif : vterm compile un
    # module C contre libvterm, ce que package.el ne peut pas faire ici
    # (il chercherait cmake/libtool/libvterm à l'exécution). Le paquet Nix
    # livre le .so déjà compilé. Le reste de la config reste sur MELPA.
    extraPackages = epkgs: [ epkgs.vterm ];
  };

  # Démarre le daemon Emacs au login (service utilisateur systemd).
  # Partagé par les 3 machines. On lance les clients avec `emacsclient`.
  services.emacs = {
    enable = true;
    # Laissé à false volontairement : cette option écrirait un wrapper
    # `emacsclient --create-frame` (fenêtre graphique) dans ~/.profile, en
    # conflit avec le `emacsclient -t -a emacs` (frame terminal) défini dans
    # modules/nixos/default.nix — seule source de vérité pour EDITOR/VISUAL.
    defaultEditor = false;
  };

  # org-protocol : capture web depuis Firefox.
  #
  # Chaîne complète : bookmarklet Firefox → URL « org-protocol://capture?… »
  # → Firefox délègue le schéma inconnu au bureau → mimeapps.list résout
  # x-scheme-handler/org-protocol vers ce desktop entry → emacsclient →
  # handler org-protocol dans Emacs → org-capture.
  #
  # Côté Emacs, org-protocol doit être chargé pour installer son handler
  # dans file-name-handler-alist : cf. init.el, section Org-mode.
  home.packages = [ orgProtocolCapture ];

  xdg.desktopEntries.org-protocol = {
    name = "org-protocol";
    exec = "${orgProtocolCapture}/bin/org-protocol-capture %u";
    icon = "emacs";
    type = "Application";
    terminal = false;
    categories = [ "Utility" ];
    mimeType = [ "x-scheme-handler/org-protocol" ];
    # Handler de schéma, pas une application à proposer dans les menus.
    noDisplay = true;
  };

  # S'ajoute aux associations déclarées dans modules/home-manager/default.nix
  # (les définitions d'un attrset se fusionnent entre modules).
  xdg.mimeApps.defaultApplications."x-scheme-handler/org-protocol" =
    "org-protocol.desktop";

  # Symlink out-of-store.
  home.file.".config/emacs/init.el".source =
    config.lib.file.mkOutOfStoreSymlink "${emacsSrc}/init.el";
  home.file.".config/emacs/early-init.el".source =
  config.lib.file.mkOutOfStoreSymlink "${emacsSrc}/early-init.el";
}
