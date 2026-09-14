# Secrets et fichiers de configuration du courriel (mbsync / msmtp).
#
# Deux comptes IMAP, un seul outil de chaque côté :
#
#   mbsync (isync)  IMAP → Maildir, dans les deux sens.
#   msmtp           envoi SMTP, appelé par Emacs comme un sendmail.
#   mu / mu4e       index et interface — côté home-manager, pas ici.
#
# Ces deux outils lisent un fichier de configuration en texte clair, qui
# mélange par nature la STRUCTURE (publique : hôtes, ports, dossiers) et les
# VALEURS (adresses et mots de passe, absents de ce dépôt public). D'où le
# recours à `sops.templates' plutôt qu'à de simples `sops.secrets' : le
# contenu des deux fichiers est écrit ci-dessous en clair et se relit sans
# rien déchiffrer, seuls les `sops.placeholder' sont substitués à
# l'activation. Le fichier rendu vit dans /run/secrets/rendered (tmpfs,
# mode 0400, propriété de cheon) et ne touche jamais le disque.
#
# Les MOTS DE PASSE ne passent pas par ces gabarits : ils sont lus à
# l'exécution dans /run/secrets par PassCmd (mbsync) et passwordeval
# (msmtp). Ce n'est pas une précaution de style, c'est une nécessité — les
# deux outils analysent leur fichier de configuration et traitent le
# guillemet double comme un délimiteur. Un mot de passe d'application Zoho
# en contenant un faisait échouer mbsync dès la lecture du fichier :
#
#   /run/secrets/rendered/mbsyncrc:12: missing closing quote
#
# Échapper la valeur est impossible ici : la substitution est faite par
# sops-install-secrets à l'activation, en texte brut, bien après
# l'évaluation Nix. Déléguer la lecture à une commande contourne le
# parseur entièrement, quel que soit le contenu du mot de passe — et a
# pour effet secondaire heureux qu'aucun mot de passe ne figure plus dans
# les fichiers rendus, qui ne contiennent que les adresses.
#
# Les cinq valeurs, toutes de simples chaînes :
#
#   courriel-nom                Nom affiché dans l'en-tête From.
#   courriel-zoho-adresse       Adresse professionnelle Zoho.
#   courriel-zoho-motdepasse    Mot de passe d'application Zoho — PAS le mot
#                               de passe du compte. Celui du CalDAV ne peut
#                               pas être réutilisé : Zoho émet un mot de passe
#                               d'application par usage.
#   courriel-gmail-adresse      Adresse Gmail personnelle.
#   courriel-gmail-motdepasse   Mot de passe d'application Google, qui exige
#                               la validation en deux étapes sur le compte.
#
# L'adresse Gmail figure déjà en clair dans modules/home-manager/default.nix
# (programs.git.settings.user.email). Elle passe malgré tout par sops ici,
# pour que les deux comptes se traitent de la même façon et que rien ne
# bloque si cette ligne de git disparaît un jour.
#
# Importé par portable et pomme seulement, comme calendrier.nix : le serveur
# n'a aucune raison de détenir ces identifiants.
#
# Procédure de première mise en place : docs/courriel.org.

{ config, ... }:
let
  # Lisible par cheon, qui fait tourner Emacs — et par personne d'autre.
  # msmtp REFUSE de démarrer si son fichier de configuration est accessible
  # au groupe ou au reste du monde ; 0400 satisfait cette vérification.
  pourEmacs = {
    owner = "cheon";
    mode = "0400";
  };

  ph = nom: config.sops.placeholder.${nom};
in
{
  sops.secrets = {
    "courriel-nom" = pourEmacs;
    "courriel-zoho-adresse" = pourEmacs;
    "courriel-zoho-motdepasse" = pourEmacs;
    "courriel-gmail-adresse" = pourEmacs;
    "courriel-gmail-motdepasse" = pourEmacs;
  };

  # ── mbsync ────────────────────────────────────────────────────────────
  #
  # Vocabulaire : depuis isync 1.4, « Far » désigne le serveur IMAP et
  # « Near » le Maildir local (anciennement Master/Slave).
  #
  # Le Maildir est sous ~/Courriel et non sous ~/Documents/Cerveau : ce
  # dernier est le seul dossier partagé par Syncthing, et deux machines qui
  # modifient en parallèle les drapeaux d'un même Maildir produisent des
  # fichiers de conflit que mbsync et mu prennent pour de vrais messages.
  # IMAP est la source de vérité ; chaque machine synchronise de son côté.
  sops.templates."mbsyncrc" = pourEmacs // {
    content = ''
      # Généré par modules/nixos/courriel.nix — ne pas éditer ici.

      # ── Zoho — professionnel ──────────────────────────────────────────
      #
      # Hôte du centre de données canadien, cohérent avec le CalDAV déjà en
      # place (calendar.zohocloud.ca, cf. modules/nixos/calendrier.nix). Un
      # compte hébergé ailleurs utiliserait imap.zoho.com ou imap.zoho.eu.
      IMAPAccount zoho
      Host imap.zohocloud.ca
      Port 993
      User ${ph "courriel-zoho-adresse"}
      PassCmd "cat /run/secrets/courriel-zoho-motdepasse"
      TLSType IMAPS

      IMAPStore zoho-distant
      Account zoho

      MaildirStore zoho-local
      Path ~/Courriel/zoho/
      Inbox ~/Courriel/zoho/INBOX
      SubFolders Verbatim

      Channel zoho
      Far :zoho-distant:
      Near :zoho-local:
      Patterns *
      Create Both
      Remove Both
      Expunge Both
      SyncState *

      # Zoho possède déjà un dossier « Archive » — il arrive par le « * »
      # ci-dessus. Gmail non : il archive en retirant l'étiquette Inbox, sans
      # dossier où déposer le message. Le dossier Gmail est donc créé
      # LOCALEMENT par `courriel-init', puis poussé vers le serveur par le
      # « Create Both ». Des deux côtés, c'est la cible de l'action de
      # classement de mu4e (touche « r »).

      # ── Google — personnel ────────────────────────────────────────────
      #
      # Liste EXPLICITE des dossiers, et non « * » suivi d'exclusions.
      #
      # Gmail n'a pas de dossiers mais des étiquettes, et « [Gmail]/All Mail »
      # les contient TOUTES : avec « * », chaque message serait téléchargé deux
      # fois et mu l'indexerait en double. Une liste positive évite aussi que
      # la création d'une étiquette côté Google fasse silencieusement gonfler
      # la synchronisation.
      #
      # Les noms sont en FRANÇAIS parce que Gmail traduit ses dossiers IMAP
      # selon la langue du COMPTE, pas celle du client. Relevés sur le compte
      # avec « mbsync -l gmail » — ne pas les remplacer par les noms anglais
      # que donne la documentation de Gmail.
      #
      # Le compte expose aussi des dossiers Drafts/Sent/Queue/Unwanted à la
      # racine, laissés par un autre client (Geary). Ils sont ignorés : les
      # dossiers canoniques de Gmail sont ceux sous [Gmail]/.
      IMAPAccount gmail
      Host imap.gmail.com
      Port 993
      User ${ph "courriel-gmail-adresse"}
      PassCmd "cat /run/secrets/courriel-gmail-motdepasse"
      TLSType IMAPS

      IMAPStore gmail-distant
      Account gmail

      MaildirStore gmail-local
      Path ~/Courriel/gmail/
      Inbox ~/Courriel/gmail/INBOX
      SubFolders Verbatim

      Channel gmail
      Far :gmail-distant:
      Near :gmail-local:
      Patterns "INBOX" "Archive" "[Gmail]/Messages envoyés" "[Gmail]/Brouillons" "[Gmail]/Corbeille" "[Gmail]/Pourriel"
      Create Both
      Remove Both
      Expunge Both
      SyncState *
    '';
  };

  # ── msmtp ─────────────────────────────────────────────────────────────
  #
  # Emacs l'appelle comme un sendmail (cf. la section Courriel d'init.el),
  # avec « -a zoho » ou « -a gmail » selon le contexte mu4e actif.
  #
  # Port 465 = TLS implicite, d'où tls_starttls off : c'est le port 587 qui
  # commence en clair avant de négocier STARTTLS.
  sops.templates."msmtprc" = pourEmacs // {
    content = ''
      # Généré par modules/nixos/courriel.nix — ne pas éditer ici.

      defaults
      auth           on
      tls            on
      tls_starttls   off
      logfile        ~/.local/state/msmtp.log

      account zoho
      host     smtp.zohocloud.ca
      port     465
      from     ${ph "courriel-zoho-adresse"}
      user     ${ph "courriel-zoho-adresse"}
      passwordeval cat /run/secrets/courriel-zoho-motdepasse

      account gmail
      host     smtp.gmail.com
      port     465
      from     ${ph "courriel-gmail-adresse"}
      user     ${ph "courriel-gmail-adresse"}
      passwordeval cat /run/secrets/courriel-gmail-motdepasse

      # Filet de sécurité : un message envoyé sans « -a » part du compte
      # professionnel plutôt que d'échouer.
      account default : zoho
    '';
  };
}
