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

;;; Secrets (sops)
;;
;; Ce dépôt est public : adresses, identifiants de calendriers et mots de
;; passe n'y figurent pas. sops-nix les déchiffre au démarrage vers
;; /run/secrets (cf. modules/nixos/calendrier.nix et courriel.nix).
;;
;; Ce sont des VALEURS et non du code : un secret ne contient qu'une chaîne,
;; jamais quelque chose qu'on exécute. Toute la logique reste dans ce
;; fichier, qui se lit intégralement sans rien déchiffrer — seules les
;; valeurs manquent à la lecture.
;;
;; Section partagée : les calendriers ci-dessous et le courriel plus bas
;; puisent aux mêmes deux fonctions.

(defun my/secret (nom)
  "Contenu du secret NOM déchiffré par sops dans /run/secrets, ou nil.
Le saut de ligne final que laissent la plupart des éditeurs est retiré :
il casserait aussi bien une URL qu'un identifiant de calendrier ou une
adresse de courriel."
  (let ((fichier (expand-file-name nom "/run/secrets/")))
    (when (file-readable-p fichier)
      (string-trim
       (with-temp-buffer
         (insert-file-contents fichier)
         (buffer-string))))))

(defun my/auth (hote)
  "Couple (IDENTIFIANT . SECRET) trouvé dans auth-source pour HOTE, ou nil.
auth-source renvoie le secret sous forme de fonction quand la source est
chiffrée ; on l'appelle pour obtenir la chaîne."
  (when-let* ((entree (car (auth-source-search :host hote :max 1))))
    (cons (plist-get entree :user)
          (let ((secret (plist-get entree :secret)))
            (if (functionp secret) (funcall secret) secret)))))

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
;; Les identifiants de calendriers n'étant pas dans ce dépôt public, ils sont
;; lus dans /run/secrets par `my/secret' (cf. la section Secrets ci-dessus et
;; modules/nixos/calendrier.nix).

;; Lus une fois au démarrage plutôt qu'à chaque usage : trois lectures de
;; fichiers minuscules, et les valeurs deviennent inspectables avec C-h v.
(defvar my/zoho-calendar-id (my/secret "calendrier-zoho-id")
  "Identifiant du calendrier professionnel, tiré de la CalDAV URL de Zoho.")

(defvar my/gcal-perso (my/secret "calendrier-gcal-perso")
  "Identifiant du calendrier Google personnel (en général l'adresse Gmail).")

(defvar my/gcal-famille (my/secret "calendrier-gcal-famille")
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

;;;; Contournement : <DAV:prop/> vide
;;
;; Zoho répond aux PROPFIND d'org-caldav avec des éléments <D:prop /> vides —
;; typiquement pour la collection elle-même, qui n'a pas d'etag à déclarer
;; avant la liste des événements. Or url-dav, le client WebDAV d'Emacs, traite
;; ce cas comme une erreur plutôt que comme une absence de propriétés :
;;
;;   (let ((children (xml-node-children node)) ...)
;;     (when (not children)
;;       (error "No child nodes in DAV:prop"))
;;
;; La synchronisation s'interrompt alors à « Updating EventDB from Cal », sans
;; rien écrire. C'est un défaut connu et non corrigé en amont — org-caldav
;; issues #126 (2017) et #239, cette dernière portant précisément sur Zoho.
;;
;; Un prop vide signifie « aucune propriété » : renvoyer nil est le
;; comportement correct, et url-dav-process-DAV:propstat s'en accommode, son
;; plist-put sur nil produisant une liste valide. On se garde donc de toucher
;; au cas nominal — l'advice ne change rien quand il y a des enfants.

(with-eval-after-load 'url-dav
  (defun my/url-dav-tolere-prop-vide (fonction-origine node)
    "Renvoie nil sur un <DAV:prop/> vide au lieu de lever une erreur."
    (if (xml-node-children node)
        (funcall fonction-origine node)
      nil))
  (advice-add 'url-dav-process-DAV:prop
              :around #'my/url-dav-tolere-prop-vide))

;; Second défaut, que le premier correctif met au jour : une fois les prop
;; vides tolérées, les ressources sans etag parviennent jusqu'à
;; org-caldav-get-icsfiles-etags-from-properties, qui ne s'en protège pas —
;;
;;   (let ((etag (plist-get (cdr prop) 'DAV:getetag)))
;;     (when (string-match "\"\\(.*\\)\"" etag)     ; etag vaut nil ici
;;
;; d'où « Wrong type argument: stringp, nil ». Une ressource sans etag n'est
;; de toute façon pas un événement — c'est la collection elle-même — donc on
;; l'écarte en amont plutôt que d'aller réécrire la fonction.

(with-eval-after-load 'org-caldav
  (defun my/org-caldav-ecarte-sans-etag (fonction-origine properties)
    "Retire de PROPERTIES les ressources dépourvues de DAV:getetag."
    (funcall fonction-origine
             (seq-filter (lambda (prop)
                           (stringp (plist-get (cdr prop) 'DAV:getetag)))
                         properties)))
  (advice-add 'org-caldav-get-icsfiles-etags-from-properties
              :around #'my/org-caldav-ecarte-sans-etag))

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
  (when-let* ((client (my/auth "org-gcal")))
    (setq org-gcal-client-id (car client)
          org-gcal-client-secret (cdr client)))

  (setq org-gcal-fetch-file-alist
        `((,my/gcal-perso   . ,(my/calendrier-file "perso-gmail.org"))
          (,my/gcal-famille . ,(my/calendrier-file "famille.org"))))

  ;; Enregistre les tampons une fois la rafale d'événements passée.
  (add-hook 'org-gcal-after-update-entry-functions
            #'my/calendriers--programmer-enregistrement))

;;;; Enregistrement des tampons
;;
;; org-gcal met à jour les tampons mais ne les enregistre pas : son seul
;; appel à `save-buffer' est dans la fonction d'archivage. Sans ce qui suit,
;; une synchronisation réussie laisse les événements en mémoire seulement —
;; « Events fetched into … » s'affiche, le fichier sur disque ne bouge pas,
;; et un redémarrage d'Emacs perd tout.

(defun my/calendriers-enregistrer ()
  "Enregistre les fichiers modifiés de `my/calendriers-directory'."
  (interactive)
  (let ((dossier (expand-file-name my/calendriers-directory))
        (n 0))
    (dolist (tampon (buffer-list))
      (with-current-buffer tampon
        (when (and buffer-file-name
                   (buffer-modified-p)
                   (file-in-directory-p buffer-file-name dossier))
          (save-buffer)
          (setq n (1+ n)))))
    (when (> n 0)
      (message "Calendriers : %d fichier(s) enregistré(s)" n))))

(defvar my/calendriers--minuteur nil
  "Minuteur d'enregistrement différé, réarmé à chaque événement reçu.")

(defun my/calendriers--programmer-enregistrement (&rest _)
  "Repousse l'enregistrement des fichiers calendrier de deux secondes.
Branché sur `org-gcal-after-update-entry-functions', qui est appelé une fois
par événement — d'où le report plutôt qu'un enregistrement immédiat : le
minuteur est annulé et réarmé à chaque entrée, et ne se déclenche donc qu'une
seule fois, la rafale terminée. C'est aussi la seule façon d'attendre la fin
d'org-gcal, qui travaille de façon asynchrone et rend la main aussitôt."
  (when (timerp my/calendriers--minuteur)
    (cancel-timer my/calendriers--minuteur))
  (setq my/calendriers--minuteur
        (run-with-idle-timer 2 nil #'my/calendriers-enregistrer)))

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
  ;; org-caldav est synchrone : à ce point son travail est terminé.
  (my/calendriers-enregistrer)
  ;; Rien à enregistrer après org-gcal : il vient seulement de démarrer, et
  ;; c'est `my/calendriers--programmer-enregistrement' qui s'en chargera.
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

;;; Courriel (mu4e)
;;
;; Un outil par étape, chacun ignorant des autres :
;;
;;   mbsync (isync)   IMAP ↔ Maildir, dans les deux sens
;;   mu               index Xapian du Maildir
;;   mu4e             interface Emacs, qui pilote les deux précédents
;;   msmtp            envoi SMTP, appelé comme un sendmail
;;
;; Deux comptes mais un seul jeu d'outils, contrairement aux calendriers
;; plus haut où Google impose org-gcal à côté d'org-caldav : en IMAP, Zoho
;; et Google parlent le même protocole. L'authentification passe des deux
;; côtés par un mot de passe d'application (cf. modules/nixos/courriel.nix).
;;
;; mu4e vient du paquet Nix `mu' et JAMAIS de MELPA — d'où le `:ensure nil'
;; ci-dessous. Ce n'est pas un paquet indépendant : c'est le code Emacs
;; livré avec le binaire `mu', avec lequel il dialogue par un protocole qui
;; change entre versions majeures (cf. modules/home-manager/courriel.nix).
;;
;; La racine du Maildir (~/Courriel) n'est délibérément réglée nulle part
;; ici : `mu4e-maildir' est obsolète depuis mu4e 1.3.8 et la valeur vient
;; désormais du serveur `mu', c'est-à-dire du `mu init --maildir' que le
;; script `courriel-init' exécute une fois par machine.
;;
;; Mise en place complète : docs/courriel.org.

(defvar my/courriel-nom (my/secret "courriel-nom")
  "Nom affiché dans l'en-tête From des messages sortants.")

(defvar my/courriel-zoho (my/secret "courriel-zoho-adresse")
  "Adresse professionnelle Zoho.")

(defvar my/courriel-gmail (my/secret "courriel-gmail-adresse")
  "Adresse personnelle Gmail.")

;; `:if' plutôt qu'un chargement inconditionnel : ce fichier est partagé par
;; les trois machines (emacs.nix est un module commun), alors que
;; courriel.nix n'est importé que par portable et pomme. Sur le serveur,
;; mu4e n'est pas sur le load-path et toute la section est simplement sautée.
(use-package mu4e
  :ensure nil
  :if (locate-library "mu4e")
  :commands (mu4e mu4e-compose-new)
  :bind ("C-c m" . mu4e)
  :config

  ;; Réglage OBLIGATOIRE avec mbsync. Un Maildir encode les drapeaux (lu,
  ;; répondu, supprimé) dans le NOM du fichier : mbsync renomme donc les
  ;; fichiers à chaque changement d'état. Si mu4e déplace un message sans
  ;; renommer, mbsync voit un fichier inchangé à un nouvel endroit et
  ;; rétablit l'ancien — les messages supprimés réapparaissent.
  (setq mu4e-change-filenames-when-moving t)

  ;; C'est mu4e qui déclenche mbsync, et non un minuteur systemd : le
  ;; processus `mu server' garde la base Xapian verrouillée, et un `mu
  ;; index' concurrent échouerait sur ce verrou. Le daemon Emacs démarrant
  ;; au login, la couverture est la même (cf. modules/home-manager/courriel.nix).
  (setq mu4e-get-mail-command "mbsync -c /run/secrets/rendered/mbsyncrc -a"
        mu4e-update-interval 300
        mu4e-index-cleanup t
        mu4e-index-lazy-check t)

  (setq mu4e-attachment-dir "~/Téléchargements"
        mu4e-confirm-quit nil
        mu4e-search-results-limit 500
        mu4e-headers-date-format "%Y-%m-%d"
        mu4e-headers-time-format "%H:%M")

  ;; format=flowed : le texte se replie chez le destinataire selon la largeur
  ;; de SA fenêtre, au lieu de porter des retours à la ligne durs à 72
  ;; colonnes — ce qui compte pour les correspondants qui lisent au téléphone.
  (setq mu4e-compose-format-flowed t)

  ;; Envoi délégué à msmtp plutôt qu'au smtpmail intégré : un seul fichier
  ;; décrit les deux comptes, et msmtp sait mettre en file d'attente — utile
  ;; sur un portable qui perd le réseau en pleine rédaction. Emacs l'appelle
  ;; par l'interface sendmail ; le compte est choisi par le « -a » que chaque
  ;; contexte pose dans `message-sendmail-extra-arguments'.
  (setq message-send-mail-function #'message-send-mail-with-sendmail
        sendmail-program (or (executable-find "msmtp") "msmtp")
        ;; Empêche message.el d'ajouter un « -f adresse » qui ferait double
        ;; emploi avec le « -a compte » et pourrait le contredire.
        message-sendmail-f-is-evil t
        message-kill-buffer-on-exit t)

  ;;;; Contextes
  ;;
  ;; `match-func' reçoit le message auquel on répond (ou nil pour un message
  ;; neuf) et décide du compte d'envoi. Le test porte sur le dossier, dont
  ;; le premier segment est le nom du Channel mbsync — /zoho ou /gmail.
  ;;
  ;; Les noms de dossiers sont en FRANÇAIS des DEUX côtés : Zoho comme Gmail
  ;; traduisent leurs dossiers IMAP selon la langue du COMPTE, pas celle du
  ;; client. Relevés avec « mbsync -l », et à garder identiques à la ligne
  ;; Patterns de modules/nixos/courriel.nix — les deux décrivent la même
  ;; arborescence. Ne pas les remplacer par les noms anglais des docs
  ;; officielles.
  (setq mu4e-contexts
        (list
         (make-mu4e-context
          :name "zoho"
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/zoho" (mu4e-message-field msg :maildir))))
          :vars `((user-full-name     . ,(or my/courriel-nom ""))
                  (user-mail-address  . ,(or my/courriel-zoho ""))
                  (mu4e-sent-folder   . "/zoho/Envoyé")
                  (mu4e-drafts-folder . "/zoho/Brouillon")
                  (mu4e-trash-folder  . "/zoho/Poubelle")
                  (mu4e-refile-folder . "/zoho/Archive")
                  (message-sendmail-extra-arguments
                   . ("-C" "/run/secrets/rendered/msmtprc" "-a" "zoho"))))

         (make-mu4e-context
          :name "gmail"
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/gmail" (mu4e-message-field msg :maildir))))
          :vars `((user-full-name     . ,(or my/courriel-nom ""))
                  (user-mail-address  . ,(or my/courriel-gmail ""))
                  (mu4e-sent-folder   . "/gmail/[Gmail]/Messages envoyés")
                  (mu4e-drafts-folder . "/gmail/[Gmail]/Brouillons")
                  (mu4e-trash-folder  . "/gmail/[Gmail]/Corbeille")
                  (mu4e-refile-folder . "/gmail/Archive")
                  (message-sendmail-extra-arguments
                   . ("-C" "/run/secrets/rendered/msmtprc" "-a" "gmail"))))))

  ;; Gmail conserve lui-même une copie de tout message envoyé par son SMTP :
  ;; laisser mu4e en déposer une seconde dans le dossier des envois les
  ;; duplique. Zoho ne le fait pas, d'où le réglage par contexte plutôt que
  ;; global — `delete' signifie « ne pas garder de copie locale ».
  (setq mu4e-sent-messages-behavior
        (lambda ()
          (if (equal "gmail" (when-let* ((ctx (mu4e-context-current)))
                               (mu4e-context-name ctx)))
              'delete 'sent)))

  (setq mu4e-context-policy 'pick-first
        mu4e-compose-context-policy 'ask-if-none)

  (setq mu4e-maildir-shortcuts
        '((:maildir "/zoho/INBOX"  :key ?z)
          (:maildir "/gmail/INBOX" :key ?g)
          (:maildir "/zoho/Archive"  :key ?Z)
          (:maildir "/gmail/Archive" :key ?G)))

  (setq mu4e-bookmarks
        '((:name "Non lus" :query "flag:unread AND NOT flag:trashed" :key ?u)
          (:name "Aujourd'hui" :query "date:today..now" :key ?t)
          (:name "Cette semaine" :query "date:7d..now" :key ?s)
          (:name "Avec pièce jointe" :query "flag:attach" :key ?p)))

  ;;;; Lien avec Org
  ;;
  ;; C'est ici que le courriel cesse d'être une île. mu4e-org apprend à
  ;; `org-store-link' à produire un lien vers un message précis, que C-c C-o
  ;; rouvre dans mu4e. La capture ci-dessous s'en sert : la tâche atterrit
  ;; dans inbox.org avec un renvoi vers le courriel, sans en copier le corps.
  (require 'mu4e-org)

  ;; Ajoutée ici et non dans la section Org : `org-capture-templates' y est
  ;; posé par un setq qui écraserait un ajout fait avant lui — même raison
  ;; que pour les templates de rendez-vous. %a insère le lien stocké.
  ;;
  ;; Accrochée à `org-capture' et non à `org' : c'est org-capture.el qui
  ;; définit `org-capture-templates'. Sur `org', le hook peut se déclencher
  ;; immédiatement — (require 'mu4e-org) ci-dessus charge org — alors que la
  ;; variable n'existe pas encore, et add-to-list échoue sur un symbole vide.
  (with-eval-after-load 'org-capture
    (add-to-list 'org-capture-templates
                 '("m" "Tâche depuis un courriel" entry
                   (file+headline "~/Documents/Cerveau/inbox.org" "Tâches")
                   "* TODO %?\n  %U\n  %a")
                 t)))

;;; Lecture des PDF (pdf-tools)
;; Une seule visionneuse pour tous les PDF, où qu'ils arrivent : fichier
;; ouvert dans dired, lien org, pièce jointe de courriel. Auparavant zathura
;; s'en chargeait par openwith (depuis retiré, voir plus bas) — mais openwith
;; ne voyait que les fichiers, jamais les pièces jointes, qui retombaient sur
;; doc-view et son appel à ghostscript, absent du système.
;;
;; pdf-tools rend les pages par epdfinfo, un serveur C lié à poppler, ce qui
;; apporte en prime ce que doc-view n'a pas : recherche plein texte (le PDF
;; répond à isearch), liens cliquables, table des matières, annotations.
;;
;; :ensure nil, même raison que vterm : le paquet vient de Nix
;; (extraPackages dans modules/home-manager/emacs.nix) et non de MELPA, qui
;; tenterait de compiler epdfinfo à la volée.

(use-package pdf-tools
  :ensure nil
  :demand t
  :config
  ;; Installe pdf-view-mode dans `auto-mode-alist' (sur .pdf) et dans
  ;; `magic-mode-alist' (sur les octets « %PDF », donc même sans extension).
  ;; L'argument no-query : sans lui, un epdfinfo jugé absent déclencherait une
  ;; question — puis une compilation dans ~/.config/emacs. Ici Nix l'a déjà
  ;; construit, la question n'a donc pas de réponse utile.
  (pdf-tools-install :no-query)

  ;; Le routage des pièces jointes vers pdf-view-mode ne se fait pas ici mais
  ;; dans la section « Pièces jointes des courriels » plus bas : il relève de
  ;; mailcap, et non de pdf-tools.

  ;; Les modes globaux activés plus haut (numéros de ligne, ligne courante)
  ;; n'ont aucun sens devant une image de page : la numérotation décale le
  ;; rendu et le surlignage barre la page d'une bande de couleur. pdf-view
  ;; tient d'ailleurs la liste de ceux qui le gênent (`pdf-view-incompatible-
  ;; modes') et avertit quand il en trouve un actif — il se contente
  ;; d'avertir, jamais de les désactiver, d'où ce crochet.
  ;;
  ;; Le contrôle part sur un minuteur d'une seconde après l'entrée dans le
  ;; mode : ce crochet, lui, s'exécute aussitôt, et trouve donc le terrain
  ;; déjà net. Même remède que pour vterm plus bas.
  (add-hook 'pdf-view-mode-hook
            (lambda ()
              (display-line-numbers-mode -1)
              (setq-local global-hl-line-mode nil))))

;;; Ouverture de fichiers externes
;; Rien à régler ici : la table mailcap de la section suivante suffit, et
;; sert désormais les trois chemins d'un même fichier bureautique.
;;
;;   Lien org — `org-open-file' ne trouve pour un .pptx ni entrée dans
;;   `org-file-apps' ni mode dans `auto-mode-alist', et retombe sur le
;;   `(t . mailcap)' d'`org-file-apps-gnu', donc sur cette même table.
;;
;;   Dans dired — E (`dired-do-open') passe le fichier au programme du
;;   bureau sans ouvrir de tampon. Intégré à Emacs 30, rien à installer.
;;
;;   Pièce jointe — section suivante.
;;
;; openwith tenait ce rôle jusqu'ici ; il est retiré parce qu'il empêchait
;; d'ENVOYER une pièce jointe bureautique. `openwith-mode' ne pose pas un
;; crochet sur find-file mais une entrée ("" . openwith-file-handler) dans
;; `file-name-handler-alist', pour l'opération `insert-file-contents' de
;; TOUS les fichiers. Or mml lit la pièce à joindre par
;; `mm-insert-file-contents' dans un tampon temporaire vide — précisément la
;; condition que ce gestionnaire guette (tampon non modifié et de taille
;; nulle). C-c C-c lançait donc LibreOffice, tuait le tampon de travail et
;; interrompait l'envoi sur « Opened X in external program ». Le défaut est
;; général, pas propre au courriel : toute lecture programmée d'un fichier
;; associé serait détournée de la même façon.
;;
;; zathura demeure installé et reste la visionneuse du bureau hors Emacs
;; (xdg.mimeApps dans modules/home-manager/default.nix).

;;; Pièces jointes des courriels (mailcap)
;; Une pièce jointe n'est jamais un fichier : gnus, qui affiche les parties
;; MIME sous mu4e, écrit la pièce dans un tampon sans nom, sur lequel ni
;; `auto-mode-alist' ni `magic-mode-alist' (qui vont par l'extension ou les
;; premiers octets) n'ont prise. Seul compte le visualiseur que
;; `mailcap-mime-info' désigne pour le type MIME annoncé dans le message.
;;
;; Faute d'entrée pour un type, gnus n'a plus rien à proposer que
;; l'enregistrement — c'est ce qui arrivait aux documents bureautiques.
;;
;; `mailcap-user-mime-data' est la liste consultée AVANT la table intégrée de
;; mailcap.el, et elle survit au `mailcap-parse-mailcaps' que gnus déclenche à
;; son premier affichage. C'est le seul point d'entrée fiable ; deux voisines
;; ne le sont pas :
;;
;;   `mailcap-add' écrit dans cette même variable une structure imbriquée par
;;   type majeur/mineur, que `mailcap-select-preferred-viewer' ne sait pas
;;   relire — elle y cherche une liste plate. Son second dépôt, dans la table
;;   calculée, est effacé par le premier `mailcap-parse-mailcaps'.
;;
;;   `setq' laisserait la valeur sous la forme lisible ci-dessous, que mailcap
;;   ignore : c'est le :set du defcustom qui la convertit vers la forme
;;   interne, d'où `customize-set-variable'. Le `require' préalable n'est pas
;;   décoratif — sans lui ce :set n'est pas encore posé.
;;
;; Le champ « type » est une expression régulière implicitement ancrée entre
;; ^ et $. Une commande externe reçoit le fichier à la place de %s ; Emacs
;; l'écrit dans un fichier temporaire qu'il efface à la fermeture du message,
;; donc éditer depuis LibreOffice suppose d'enregistrer ailleurs d'abord.

(require 'mailcap)
(customize-set-variable
 'mailcap-user-mime-data
 '((pdf-view-mode "application/pdf")
   ;; Formats OpenDocument (.odt .ods .odp) et OOXML (.docx .xlsx .pptx).
   ("libreoffice %s" "application/vnd\\.oasis\\.opendocument\\..*")
   ("libreoffice %s" "application/vnd\\.openxmlformats-officedocument\\..*")
   ;; Formats hérités : .doc, .xls, .ppt, .rtf.
   ("libreoffice %s" "application/\\(msword\\|rtf\\|vnd\\.ms-\\(excel\\|powerpoint\\)\\)")))

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
