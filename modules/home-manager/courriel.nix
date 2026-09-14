# Module Courriel — la partie utilisateur.
#
# Les secrets et les deux fichiers de configuration (mbsyncrc, msmtprc) sont
# rendus par modules/nixos/courriel.nix dans /run/secrets/rendered.
# Ici : les binaires, mu4e, et le script d'initialisation de l'index.
#
# Pas de minuteur systemd pour mbsync, délibérément. C'est mu4e qui déclenche
# la synchronisation (`mu4e-get-mail-command', toutes les cinq minutes), pour
# une raison technique : mu4e fait tourner un processus `mu server' qui garde
# la base Xapian VERROUILLÉE. Un `mu index' lancé en parallèle par systemd
# échouerait sur ce verrou. Le daemon Emacs démarrant au login (cf.
# emacs.nix), la couverture est la même.
#
# Procédure de première mise en place : docs/courriel.org.

{ config, pkgs, ... }:

let
  mbsyncrc = "/run/secrets/rendered/mbsyncrc";

  # Initialisation, à lancer UNE fois par machine (cf. docs/courriel.org).
  #
  # `mu init' a besoin des adresses pour distinguer les messages reçus de
  # ceux qu'on a envoyés — c'est ce qui permet à mu4e d'afficher le
  # destinataire plutôt que l'expéditeur dans le dossier des envois. Le
  # script les lit dans /run/secrets plutôt que de les faire retaper : elles
  # n'ont pas à transiter par l'historique du shell.
  courrielInit = pkgs.writeShellScriptBin "courriel-init" ''
    set -euo pipefail

    for f in courriel-zoho-adresse courriel-gmail-adresse; do
      if [ ! -r "/run/secrets/$f" ]; then
        echo "Secret /run/secrets/$f illisible — sops a-t-il été renseigné ?" >&2
        exit 1
      fi
    done

    zoho=$(cat /run/secrets/courriel-zoho-adresse)
    gmail=$(cat /run/secrets/courriel-gmail-adresse)

    mkdir -p "$HOME/Courriel"

    # Dossier de classement Gmail, cible de la touche « r » dans mu4e. Créé
    # ici parce que Gmail archive en retirant l'étiquette Inbox, sans dossier
    # de destination ; mbsync le pousse ensuite vers le serveur grâce à
    # « Create Both ». Rien à faire pour Zoho, qui a déjà son « Archive ».
    for sous in cur new tmp; do
      mkdir -p "$HOME/Courriel/gmail/Archive/$sous"
    done

    echo "→ Première synchronisation (peut être longue)…"
    ${pkgs.isync}/bin/mbsync -c ${mbsyncrc} -a

    echo "→ Création de l'index mu…"
    ${pkgs.mu}/bin/mu init --maildir="$HOME/Courriel" \
      --my-address="$zoho" --my-address="$gmail"
    ${pkgs.mu}/bin/mu index

    echo "Terminé. Lancer mu4e dans Emacs avec C-c m."
  '';
in
{
  home.packages = [
    pkgs.isync   # mbsync : IMAP ↔ Maildir
    pkgs.mu      # index Xapian + binaire dont mu4e est le pendant Emacs
    pkgs.msmtp   # envoi SMTP
    courrielInit
  ];

  # mu4e vient de Nix et JAMAIS de MELPA — même raison que vterm dans
  # emacs.nix, mais plus contraignante encore : mu4e n'est pas un paquet
  # indépendant, c'est le code Emacs livré AVEC le binaire `mu', et il
  # dialogue avec lui par un protocole qui change entre versions majeures.
  # Une version MELPA dériverait de celle du binaire et casserait en
  # silence. Ici les deux sortent de la même dérivation nixpkgs.
  programs.emacs.extraPackages = epkgs: [ epkgs.mu4e ];
}
