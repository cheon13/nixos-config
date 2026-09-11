;;; init.el --- Configuration Emacs vanilla -*- lexical-binding: t; -*-
;;
;; Config vanilla construite par étapes en remplacement de Doom Emacs.
;; Les commentaires expliquent le *pourquoi* des choix, pour pouvoir y
;; revenir dans 6 mois sans redécouvrir le raisonnement.
;;
;; Le réglage du seuil GC vit maintenant dans early-init.el (chargé
;; avant ce fichier). Ici, on restaure juste les valeurs normales une
;; fois le chargement terminé.

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 20 1024 1024)   ; 20 Mo en usage normal
                  gc-cons-percentage 0.1)))

;;; Gestion des paquets
;; package.el natif + use-package, sans straight.el ni elpaca — le choix
;; le plus simple pour rester proche du vanilla.

(require 'package)
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/packages/")
        ("melpa"  . "https://melpa.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)   ; installe automatiquement si absent

;;; Fichier de customizations séparé
;; Sans ça, Emacs écrit automatiquement (via M-x customize-*, ou certains
;; paquets qui proposent d'enregistrer un réglage) directement dans
;; init.el, ce qui mélange config écrite à la main et config générée.
;; Chargé tôt : init.el garde le dernier mot sur tout réglage qui serait
;; sauvegardé ici par erreur (ex: un thème testé via customize-themes).
(setq custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;;; Accès rapide à index.org
;; Le lancement "avec index.org" est géré par un raccourci DWL dédié qui
;; ouvre Emacs directement sur ce fichier. Ici, on garde seulement C-c i
;; pour y revenir depuis n'importe quel autre buffer/session.

(defvar my/index-file "~/Documents/Cerveau/index.org")
(global-set-key (kbd "C-c i") (lambda () (interactive) (find-file my/index-file)))

;; Dossier des fichiers de calendrier synchronisés. Déclaré ici et non dans
;; la section « Synchronisation des calendriers » plus bas, parce que
;; org-agenda-files en a besoin avant elle.
(defvar my/calendriers-directory "~/Documents/Cerveau/Calendriers/"
  "Dossier des fichiers de calendrier.
Chaque fichier y est à la fois la source exportée vers le calendrier
distant et la boîte de réception des événements créés à distance.")

;;; Thème
;; doom-themes fonctionne indépendamment du framework Doom — juste une
;; collection de thèmes. doom-themes-org-config harmonise la
;; fontification native d'org (blocs de code, citations) avec le thème.

(use-package doom-themes
  :config
  (load-theme 'doom-pine t)
  (doom-themes-org-config)
  ;; Fix contraste mode-line : contrairement à doom-one/modus-vivendi,
  ;; doom-pine rend la mode-line active moins visible que l'inactive.
  ;; doom-color va chercher dans la palette du thème chargé, donc la
  ;; correction reste cohérente avec les teintes de doom-pine.
  (set-face-attribute 'mode-line nil
                       :background (doom-color 'green)
                       :foreground (doom-color 'bg))
  (set-face-attribute 'mode-line-inactive nil
                       :background (doom-color 'bg-alt)
                       :foreground (doom-color 'fg-alt)))

;;; which-key
;; Affiche les raccourcis disponibles après un préfixe (ex: C-c p montre
;; les bindings projectile). Utile avec le nombre grandissant de préfixes.

(use-package which-key
  :init (which-key-mode 1))

;;; Interface de base
;; Équivalent minimal du module :ui de Doom : pas de barres d'outils, pas
;; de cloche sonore, numéros de ligne et ligne courante visibles.

(setq inhibit-startup-screen t
      ring-bell-function 'ignore
      use-short-answers t            ; y/n au lieu de yes/no
      delete-by-moving-to-trash t    ; déplace vers la corbeille plutôt que suppression définitive
      ;; init.el est un symlink vers le dépôt ~/.dotfiles (géré par
      ;; home-manager). Sans ça, Emacs demande à chaque ouverture
      ;; « Symbolic link git-controlled source file; follow link? ».
      vc-follow-symlinks t)          ; suivre le lien sans poser de question

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)
(global-display-line-numbers-mode 1)
(global-hl-line-mode 1)
(global-set-key [remap list-buffers] 'ibuffer)
(global-set-key (kbd "M-o") 'other-window)

;; Police : Adwaita Mono à 12pt (chasse fixe — important pour l'alignement
;; des tableaux org et du code). Ajustement à la volée : C-x C-+, C-x C--.
(set-face-attribute 'default nil :font "Adwaita Mono-12")
(add-to-list 'default-frame-alist '(font . "Adwaita Mono-12"))

;; Chasse variable, utilisée par la face `variable-pitch' — donc par
;; mixed-pitch dans writeroom (voir plus bas), seul endroit où on la
;; veut. Noto Serif plutôt que DejaVu Serif : elle vient de noto-fonts,
;; déjà déclaré dans fonts.packages (modules/nixos/default.nix), alors
;; que DejaVu n'est là qu'au titre de famille de repli de fontconfig.
(set-face-attribute 'variable-pitch nil :family "Noto Serif")

;; mixed-pitch remappe les tableaux et le code sur la face `fixed-pitch',
;; dont la famille par défaut est « Monospace » — que fontconfig résout
;; ici en DejaVu Sans Mono. Sans cette ligne, les tableaux changeraient
;; donc de police en entrant dans writeroom. On la fixe sur la même
;; police que la face `default' pour que la chasse fixe reste identique
;; partout. Pas de taille : elle hérite ainsi du zoom (C-x C-+).
(set-face-attribute 'fixed-pitch nil :family "Adwaita Mono")

;; Transparence du fond du cadre (0 = invisible, 100 = opaque). Ne touche
;; que la couleur de fond par défaut : les faces à fond explicite
;; (hl-line, région, mode-line) restent opaques, ce qui garde le texte
;; lisible par-dessus le papier peint.
;; Nécessite Emacs 29+ et un compositeur — les deux sont là : build
;; emacs-pgtk (cf. modules/home-manager/emacs.nix) sous dwl/wlroots.
;; Deux lignes, comme pour la police : `default-frame-alist' vaut pour les
;; cadres créés ensuite (emacsclient), `set-frame-parameter' rattrape le
;; cadre initial, créé avant le chargement de ce fichier.
(set-frame-parameter nil 'alpha-background 90)
(add-to-list 'default-frame-alist '(alpha-background . 90))

;; Sauvegardes regroupées dans un sous-répertoire plutôt qu'éparpillées.
;; Création automatique des dossiers pour ne pas dépendre d'une étape
;; manuelle au premier lancement sur une nouvelle machine.
(let ((backup-dir (locate-user-emacs-file "backups"))
      (autosave-dir (locate-user-emacs-file "autosaves/")))
  (make-directory backup-dir t)
  (make-directory autosave-dir t)
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,autosave-dir t))))

;;; Complétion
;; vertico + orderless + marginalia + consult — équivalent du module
;; :completion vertico de Doom, sans le reste du framework.

(use-package vertico
  :init (vertico-mode 1))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :init (marginalia-mode 1))

(use-package consult
  :init
  (recentf-mode 1)   ; nécessaire pour que consult-buffer inclue les
                      ; fichiers récents en plus des buffers ouverts
  :bind (("C-x b" . consult-buffer)
         ("M-y"   . consult-yank-pop)))

;;; Projets (projectile)
;; Détection automatique des projets (racine via .git…). LAZY : se charge
;; au premier C-c p. Le template de capture « p » dégrade gracieusement
;; sans lui (bound-and-true-p renvoie nil tant qu'il n'est pas chargé,
;; donc juste la liste Aires/ jusqu'au premier usage de C-c p).

(use-package projectile
  :bind-keymap ("C-c p" . projectile-command-map)
  :config
  (projectile-mode 1))

;;; Magit
;; C-x g pour ouvrir le statut du dépôt.

(use-package magit
  :bind ("C-x g" . magit-status))

;;; Org-mode
;; LAZY : avec deux raccourcis DWL séparés (Emacs vide vs Emacs+index.org),
;; il n'y a plus besoin de forcer org à charger à chaque lancement — org
;; se charge de lui-même dès qu'un fichier .org est ouvert, ou via C-c a/c.

(use-package org
  :ensure nil   ; built-in, pas besoin de le télécharger
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture))
  :config
  (setq org-directory "~/Documents/Cerveau/")
  (setq org-return-follows-link t)  ; RET sur un lien le suit, plutôt qu'insérer une nouvelle ligne

  (setq org-agenda-files
        (append
         ;; (directory-files-recursively "~/Documents/Cerveau/Projets/" "\\.org$")
         (directory-files-recursively "~/Documents/Cerveau/Aires/" "\\.org$")
         (list my/calendriers-directory)
         '("~/Documents/Cerveau/")))

  ;; Équivalent de projectile-invalidate-cache pour l'agenda : org-agenda-files
  ;; est calculé une seule fois au chargement, donc un nouveau fichier .org
  ;; sous Aires/ n'apparaît pas tant qu'on ne relance pas ce scan (ou Emacs).
  (defun my/refresh-agenda-files ()
    "Recalcule org-agenda-files (nouveaux fichiers .org sous Aires/ inclus)."
    (interactive)
    (setq org-agenda-files
          (append
           (directory-files-recursively "~/Documents/Cerveau/Aires/" "\\.org$")
           (list my/calendriers-directory)
           '("~/Documents/Cerveau/")))
    (message "org-agenda-files rafraîchi (%d fichiers)" (length org-agenda-files)))

  ;; Export PDF via LuaLaTeX, locale française, classe article
  ;; personnalisée (marges 3cm, sections non numérotées).
  (require 'ox-latex)
  (setq org-latex-compiler "lualatex")
  (setq org-export-with-toc nil)
  ;; Ménage automatique des fichiers auxiliaires après un export PDF réussi
  ;; (.aux, .log, .out, .fls…) ; « tex » s'ajoute à la liste par défaut pour
  ;; ne conserver que le PDF. En cas d'échec de compilation, Org signale une
  ;; erreur avant le nettoyage : les journaux restent pour le diagnostic.
  (setq org-latex-remove-logfiles t)
  (add-to-list 'org-latex-logfiles-extensions "tex")
  (setq org-export-default-language "fr")
  (setq org-latex-classes
        '(("article"
           "\\documentclass[12pt,letterpaper]{article}
\\usepackage{geometry}
\\geometry{margin=3cm}
\\usepackage{amssymb}
\\setcounter{secnumdepth}{0}
\\usepackage[french]{babel}
[DEFAULT-PACKAGES]
[PACKAGES]
[EXTRA]"
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))

  ;; Chargé après le setq ci-dessus : ox-beamer réenregistre lui-même sa
  ;; classe « beamer » dans org-latex-classes (sinon écrasée par le setq).
  (require 'ox-beamer)

  ;; Templates de capture : selon le contexte, une note va dans un inbox
  ;; générique à trier, ou directement dans un projet précis.
  ;;   t = tâche rapide → inbox.org
  ;;   n = note rapide  → inbox.org
  ;;   p = note dans un projet → liste projectile + dossiers Aires/,
  ;;       écrite dans un notes.org à la racine du choix (co-localisé).
  (defun my/capture-target-notes ()
    "Choisit un projet projectile ou un domaine Aires/, retourne son notes.org."
    (let* ((projects (bound-and-true-p projectile-known-projects))
           (aires (directory-files "~/Documents/Cerveau/Aires/" t
                                    directory-files-no-dot-files-regexp))
           (choix (completing-read "Projet/domaine : " (append projects aires))))
      (expand-file-name "notes.org" choix)))

  (setq org-capture-templates
        '(("t" "Tâche rapide (inbox)" entry
           (file+headline "~/Documents/Cerveau/inbox.org" "Tâches")
           "* TODO %?\n  %U")

          ("n" "Note rapide (inbox)" entry
           (file+headline "~/Documents/Cerveau/inbox.org" "Notes")
           "* %?\n  %U")

          ("p" "Note dans un projet" entry
           (file my/capture-target-notes)
           "* %?\n  %U")

          ;; Déclenchés depuis Firefox via org-protocol (cf. ci-dessous) et
          ;; non depuis C-c c : les %: viennent des paramètres de l'URL —
          ;; %:link (url), %:description (title), %i (texte sélectionné).
          ("L" "Lien web (org-protocol)" entry
           (file+headline "~/Documents/Cerveau/inbox.org" "Liens")
           "* [[%:link][%:description]]\n  %U"
           :immediate-finish t)

          ("w" "Extrait web (org-protocol)" entry
           (file+headline "~/Documents/Cerveau/inbox.org" "Notes")
           "* %:description\n  %U\n  [[%:link][source]]\n\n  #+begin_quote\n  %i\n  #+end_quote\n\n  %?")))

  ;; Referme la frame dédiée créée par org-protocol-capture (cf. emacs.nix).
  ;; Le test sur le nom laisse intactes les captures lancées par C-c c depuis
  ;; une frame ordinaire.
  (defun my/org-capture-delete-frame ()
    "Ferme la frame « org-capture » à la fin d'une capture."
    (when (equal "org-capture" (frame-parameter nil 'name))
      (delete-frame)))
  (add-hook 'org-capture-after-finalize-hook #'my/org-capture-delete-frame))

;;; org-protocol
;; C'est `org-protocol' qui installe dans `file-name-handler-alist' le handler
;; interceptant les arguments « org-protocol://… » passés à emacsclient. Il
;; doit donc être chargé AVANT l'arrivée de l'URL : impossible de s'en remettre
;; au chargement paresseux d'org ci-dessus, qui n'aurait lieu qu'une fois
;; l'URL déjà traitée (et donc ouverte comme un nom de fichier littéral).
;;
;; Le timer d'inactivité préserve malgré tout un démarrage léger : le daemon
;; rend la main immédiatement au login, et charge org une seconde plus tard.
(run-with-idle-timer 1 nil (lambda () (require 'org-protocol)))

;; org-superstar : remplace les astérisques bruts par des glyphes Unicode.
(use-package org-superstar
  :hook (org-mode . org-superstar-mode))

;; Repli visuel des longues lignes aux limites des mots, sans insérer de
;; vrais retours à la ligne dans le fichier (comme 'wrap' dans vim).
(add-hook 'org-mode-hook #'visual-line-mode)

;; Mode sans distraction : centre une colonne étroite et masque le
;; superflu (mode-line, fringes). Bascule manuelle via C-c w, pas de
;; hook automatique — on l'active seulement quand on veut écrire.
;;
;; mixed-pitch fait le travail que `variable-pitch-mode' ferait trop
;; brutalement : il bascule la prose en chasse variable, mais garde en
;; chasse fixe toutes les faces listées dans
;; `mixed-pitch-fixed-pitch-faces' — tableaux org, blocs de code,
;; verbatim, formules, mots-clés, numéros de ligne. L'alignement des
;; tableaux survit donc au passage en Noto Serif.
;; :defer t → chargé au premier appel (autoload), pas au démarrage.
(use-package mixed-pitch
  :defer t)

(use-package writeroom-mode
  :bind ("C-c w" . writeroom-mode)
  :custom
  (writeroom-width 95)                      ; largeur de la colonne
  (writeroom-fullscreen-effect 'maximized)
  :config
  ;; writeroom délègue les marges à visual-fill-column. Par défaut celui-ci
  ;; garde la largeur en pixels constante au zoom, ce qui fait varier le
  ;; nombre de colonnes. À nil, il fige les 70 caractères quelle que soit
  ;; la taille de police.
  (setq visual-fill-column-adjust-for-text-scale nil)
  ;; writeroom ne touche pas aux numéros de ligne par défaut : on ajoute
  ;; un effet local qui les éteint à l'activation, les rallume à la sortie.
  (add-to-list 'writeroom-local-effects
               (lambda (arg) (display-line-numbers-mode (if (> arg 0) -1 1))))
  ;; Même principe pour la chasse variable : local au tampon, et défait
  ;; automatiquement en quittant writeroom. Hors writeroom, la config
  ;; reste intégralement en chasse fixe.
  (add-to-list 'writeroom-local-effects
               (lambda (arg) (mixed-pitch-mode (if (> arg 0) 1 -1)))))

;;; Synchronisation des calendriers
;;
;; Trois calendriers, deux outils. La répartition ne vient pas d'une
;; préférence technique mais de là où vivent réellement les calendriers :
;;
;;   - Zoho (professionnel) : CalDAV standard → org-caldav, bidirectionnel.
;;   - Google (personnel + familial partagé) : Google a fermé son point
;;     d'accès CalDAV derrière OAuth2, et la doc d'org-caldav porte
;;     elle-même l'avertissement « may be currently broken » pour Google,
;;     avec la recommandation d'utiliser un autre fournisseur. On passe
;;     donc par org-gcal, qui attaque l'API Calendar v3 directement.
;;
;; Deux outils pour trois calendriers, pas trois : org-gcal gère les deux
;; calendriers Google dans une seule alist. Tout consolider chez un seul
;; fournisseur a été étudié et écarté — Zoho ne partage un calendrier en
;; écriture qu'avec des comptes Zoho (la famille est sur Google) et réserve
;; le CalDAV des calendriers partagés à ses plans payants ; et déplacer le
;; professionnel chez Google supposerait de changer l'adresse
;; professionnelle. Le détail est dans docs/synchronisation-calendriers.org.
;;
;; ATTENTION : la synchronisation bidirectionnelle appose une propriété ID
;; sur chaque entrée synchronisée, des deux côtés. C'est le seul moyen
;; fiable d'apparier une entrée Org et un événement distant, et c'est
;; irréversible en pratique. D'où le choix de fichiers dédiés sous
;; Calendriers/ plutôt qu'un export depuis Aires/ : le périmètre reste net
;; et les fichiers de notes existants restent intacts.

(defun my/calendrier-file (nom)
  "Chemin absolu du fichier calendrier NOM, sous `my/calendriers-directory'."
  (expand-file-name nom my/calendriers-directory))

;;;; Identifiants
;;
;; Ce dépôt est public : les identifiants de calendriers et les mots de passe
;; n'y figurent pas. sops-nix les déchiffre au démarrage vers /run/secrets
;; (cf. modules/nixos/calendrier.nix).
;;
;; Ce sont des VALEURS et non du code : un secret ne contient qu'une chaîne,
;; jamais quelque chose qu'on exécute. Toute la logique reste ici, et cette
;; section se lit intégralement sans rien déchiffrer — seules les valeurs
;; manquent à la lecture.

(defun my/calendrier-secret (nom)
  "Contenu du secret NOM déchiffré par sops dans /run/secrets, ou nil.
Le saut de ligne final que laissent la plupart des éditeurs est retiré :
il casserait aussi bien une URL qu'un identifiant de calendrier."
  (let ((fichier (expand-file-name nom "/run/secrets/")))
    (when (file-readable-p fichier)
      (string-trim
       (with-temp-buffer
         (insert-file-contents fichier)
         (buffer-string))))))

(defun my/calendrier-auth (hote)
  "Couple (IDENTIFIANT . SECRET) trouvé dans auth-source pour HOTE, ou nil.
auth-source renvoie le secret sous forme de fonction quand la source est
chiffrée ; on l'appelle pour obtenir la chaîne."
  (when-let* ((entree (car (auth-source-search :host hote :max 1))))
    (cons (plist-get entree :user)
          (let ((secret (plist-get entree :secret)))
            (if (functionp secret) (funcall secret) secret)))))

;; Lus une fois au démarrage plutôt qu'à chaque usage : trois lectures de
;; fichiers minuscules, et les valeurs deviennent inspectables avec C-h v.
(defvar my/zoho-calendar-id (my/calendrier-secret "calendrier-zoho-id")
  "Identifiant du calendrier professionnel, tiré de la CalDAV URL de Zoho.")

(defvar my/gcal-perso (my/calendrier-secret "calendrier-gcal-perso")
  "Identifiant du calendrier Google personnel (en général l'adresse Gmail).")

(defvar my/gcal-famille (my/calendrier-secret "calendrier-gcal-famille")
  "Identifiant du calendrier Google familial partagé.")

(unless (and my/zoho-calendar-id my/gcal-perso my/gcal-famille)
  (message "Calendriers : identifiants absents de /run/secrets — synchronisation non configurée"))

;; Le mot de passe d'application Zoho et le couple client OAuth2 de Google
;; passent par auth-source : org-caldav s'authentifie via le paquet `url',
;; qui ne sait consulter que lui. Le format netrc n'est donc pas un choix.
(let ((netrc "/run/secrets/calendrier-authinfo"))
  (when (file-readable-p netrc)
    (require 'auth-source)
    (add-to-list 'auth-sources netrc)))

;; Fuseau du calendrier distant. À défaut, ox-icalendar exporte sans
;; référence de fuseau et les événements se décalent de quelques heures.
(setq org-icalendar-timezone "America/Toronto")

;; Le dossier doit exister avant la première synchronisation : org-caldav
;; comme org-gcal écrivent dedans sans le créer.
(make-directory my/calendriers-directory t)

;;;; Zoho — professionnel (org-caldav)

(use-package org-caldav
  :defer t
  :commands (org-caldav-sync)
  :init
  ;; Le %s n'est pas une coquille : chez Zoho l'identifiant du calendrier
  ;; est au MILIEU du chemin, suivi de /events/. org-caldav-events-url teste
  ;; la présence d'un %s dans l'URL et y substitue org-caldav-calendar-id ;
  ;; sans lui, il collerait l'identifiant à la fin et viserait une URL
  ;; inexistante. Le domaine dépend du centre de données du compte —
  ;; zohocloud.ca pour un compte canadien — et doit être identique à celui
  ;; de l'entrée netrc, qu'auth-source apparie sur le nom d'hôte exact.
  (setq org-caldav-url "https://calendar.zohocloud.ca/caldav/%s/events"
        org-caldav-calendar-id my/zoho-calendar-id
        ;; L'inbox est ajoutée d'office à org-caldav-files, et c'est ici le
        ;; même fichier — source et destination à la fois. D'où le nil.
        org-caldav-inbox (my/calendrier-file "pro-zoho.org")
        org-caldav-files nil
        ;; L'état de synchronisation vit à côté des fichiers org plutôt que
        ;; dans ~/.config/emacs : s'ils sont un jour synchronisés entre
        ;; machines, il doit voyager avec eux — sinon la seconde machine
        ;; croirait tous les événements nouveaux et les dupliquerait.
        org-caldav-save-directory my/calendriers-directory
        ;; Demande confirmation des deux côtés plutôt que de supprimer en
        ;; silence. À desserrer une fois la confiance établie.
        org-caldav-delete-org-entries 'ask
        org-caldav-delete-calendar-entries 'ask))

;;;; Google — personnel et familial (org-gcal)

(use-package org-gcal
  :defer t
  :commands (org-gcal-sync org-gcal-fetch org-gcal-post-at-point)
  ;; Tout en :init et rien en :config, contrairement à l'évidence — org-gcal.el
  ;; se termine par un test de niveau supérieur, exécuté PENDANT le chargement
  ;; du fichier et donc avant tout :config :
  ;;
  ;;   (if (and org-gcal-client-id org-gcal-client-secret)
  ;;       (org-gcal-reload-client-id-secret)
  ;;     (warn "org-gcal: must set ..."))
  ;;
  ;; C'est ce test qui enregistre le fournisseur Google dans
  ;; `oauth2-auto-additional-providers-alist'. Renseigner les identifiants en
  ;; :config arrive trop tard : les variables sont bien posées, mais
  ;; l'enregistrement OAuth2 n'a jamais eu lieu, et org-gcal émet un
  ;; avertissement en invitant à lancer `org-gcal-reload-client-id-secret' à la
  ;; main. En :init, les variables existent avant le chargement et org-gcal
  ;; s'enregistre lui-même.
  ;;
  ;; Le surcoût au démarrage est une lecture du netrc, soit quelques
  ;; millisecondes — le paquet lui-même reste chargé paresseusement.
  :init
  ;; plstore sert de coffre au jeton OAuth2, chiffré par GPG. Sans ce
  ;; réglage il redemande la passphrase à chaque accès, soit plusieurs fois
  ;; par synchronisation.
  (setq plstore-cache-passphrase-for-symmetric-encryption t)

  ;; Le client OAuth2 est une paire identifiant/secret : auth-source est
  ;; fait pour ça, inutile de lui inventer un autre rangement.
  (when-let* ((client (my/calendrier-auth "org-gcal")))
    (setq org-gcal-client-id (car client)
          org-gcal-client-secret (cdr client)))

  (setq org-gcal-fetch-file-alist
        `((,my/gcal-perso   . ,(my/calendrier-file "perso-gmail.org"))
          (,my/gcal-famille . ,(my/calendrier-file "famille.org")))))

;;;; Commande unifiée

(defun my/calendriers-sync ()
  "Synchronise les trois calendriers : Zoho via org-caldav, Google via org-gcal.
Les deux outils sont appelés l'un après l'autre, chacun protégé : une
panne d'un fournisseur ne doit pas empêcher l'autre de se synchroniser.

org-gcal travaille de façon asynchrone : sa partie se termine après le
retour de cette commande."
  (interactive)
  (condition-case err
      (org-caldav-sync)
    (error (message "Zoho (org-caldav) : %s" (error-message-string err))))
  (condition-case err
      (org-gcal-sync)
    (error (message "Google (org-gcal) : %s" (error-message-string err)))))

(global-set-key (kbd "C-c s") #'my/calendriers-sync)

;;;; Capture de rendez-vous
;;
;; Remplace le template « r » d'origine, qui déposait les rendez-vous dans
;; inbox.org — donc hors de tout calendrier synchronisé, et sans jamais
;; atteindre le téléphone. Un template par calendrier, puisque la
;; destination détermine le fichier.
;;
;; Côté Google, le template inscrit lui-même la propriété calendar-id :
;; sans elle, org-gcal demande le calendrier à chaque publication. Le
;; SCHEDULED plutôt qu'un timestamp nu est reconnu par org-gcal comme la
;; date de l'événement, et il alimente l'agenda de la même façon.
;;
;; with-eval-after-load et non le bloc org plus haut : org-capture-templates
;; y est posé par un setq, qui écraserait un ajout fait avant lui.

(with-eval-after-load 'org
  (dolist (tpl
           (list
            `("r" "Rendez-vous")

            `("rp" "Rendez-vous professionnel (Zoho)" entry
              (file ,(my/calendrier-file "pro-zoho.org"))
              "* %^{Nom du rendez-vous}\n%^T\n%?")

            `("rc" "Rendez-vous personnel (Google)" entry
              (file ,(my/calendrier-file "perso-gmail.org"))
              ,(concat "* %^{Nom du rendez-vous}\nSCHEDULED: %^T\n"
                       ":PROPERTIES:\n:calendar-id: " (or my/gcal-perso "")
                       "\n:END:\n%?"))

            `("rf" "Rendez-vous familial (Google partagé)" entry
              (file ,(my/calendrier-file "famille.org"))
              ,(concat "* %^{Nom du rendez-vous}\nSCHEDULED: %^T\n"
                       ":PROPERTIES:\n:calendar-id: " (or my/gcal-famille "")
                       "\n:END:\n%?"))))
    (add-to-list 'org-capture-templates tpl t)))

;;; Ouverture de fichiers externes
;; openwith intercepte l'ouverture globalement (dired, find-file, liens
;; org) — plus large qu'org-file-apps qui ne couvre que les liens org.

(use-package openwith
  :config
  (setq openwith-associations
        '(("\\.pdf\\'" "zathura" (file))
          ("\\.\\(ods\\|odt\\|odp\\|docx\\|xlsx\\|pptx\\)\\'" "libreoffice" (file))))
  (openwith-mode 1))

;;; Terminal (vterm)
;; Vrai émulateur de terminal (liaison C vers libvterm), contrairement à
;; term/eshell qui sont en Elisp : rendu rapide, true color, et les
;; applications plein écran (htop, tmux, nvim, pagers) fonctionnent.
;;
;; :ensure nil est ESSENTIEL ici — le paquet vient de Nix
;; (programs.emacs.extraPackages dans modules/home-manager/emacs.nix) et
;; non de MELPA. Sans ça, use-package-always-ensure tenterait de le
;; réinstaller et de compiler le module natif à la volée.

(use-package vterm
  :ensure nil
  :bind ("C-c t" . vterm)
  :custom
  (vterm-max-scrollback 10000)
  :config
  ;; Les modes globaux (numéros de ligne, ligne courante) n'ont pas de sens
  ;; dans un terminal et perturbent l'alignement des applications curses.
  (add-hook 'vterm-mode-hook
            (lambda ()
              (display-line-numbers-mode -1)
              (setq-local global-hl-line-mode nil))))

;;; Correction orthographique (hunspell)
;; hunspell et les dictionnaires viennent de Nix (hunspellDicts.fr-any et
;; hunspellDicts.en_US dans modules/home-manager/default.nix).
;;
;; Pourquoi ispell-dictionary est OBLIGATOIRE ici : au démarrage, hunspell
;; déduit son dictionnaire par défaut de $LANG, soit « fr_CA » sur cette
;; machine. Or fr-any installe le dictionnaire sous le nom
;; « fr-toutesvariantes » — il n'existe pas de fr_CA. hunspell démarre donc
;; sans dictionnaire chargé, et ispell échoue avec le message
;; « Can't find Hunspell dictionary with a .aff affix file ».
;; En fixant ispell-dictionary, ispell relance la détection avec
;; « -d fr-toutesvariantes » et trouve bien le fichier .aff.
;;
;; C-c d bascule vers l'anglais (en_US) dans le tampon courant.

(use-package ispell
  :ensure nil                          ; intégré à Emacs
  :bind ("C-c d" . ispell-change-dictionary)
  :custom
  (ispell-program-name "hunspell")
  (ispell-dictionary "fr-toutesvariantes")
  ;; Dictionnaire personnel commun aux deux langues, versionné hors dépôt.
  (ispell-personal-dictionary (locate-user-emacs-file "dictionnaire-perso")))

;; Vérification à la volée : soulignement des fautes pendant la frappe.
;; Uniquement dans les modes texte (org, markdown, LaTeX…) ; en mode
;; programmation on se limite aux commentaires et chaînes via
;; flyspell-prog-mode, pour ne pas signaler chaque identifiant.
(use-package flyspell
  :ensure nil
  :hook ((text-mode . flyspell-mode)
         (prog-mode . flyspell-prog-mode))
  :custom
  ;; Le menu souris par défaut est peu pratique au clavier ; M-$ sur un mot
  ;; (ispell-word) reste la façon normale de corriger.
  (flyspell-issue-message-flag nil))   ; évite un message à chaque mot vérifié

;;; Langages additionnels
;; Org et Elisp sont colorisés nativement. Markdown et Nix ont besoin
;; d'un mode dédié, absent du vanilla par défaut.

(use-package markdown-mode
  :mode ("\\.md\\'" . markdown-mode))

(use-package nix-mode
  :mode ("\\.nix\\'" . nix-mode))

;;; init.el ends here
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
