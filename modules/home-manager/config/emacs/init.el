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
           '("~/Documents/Cerveau/")))
    (message "org-agenda-files rafraîchi (%d fichiers)" (length org-agenda-files)))

  ;; Export PDF via LuaLaTeX, locale française, classe article
  ;; personnalisée (marges 3cm, sections non numérotées).
  (require 'ox-latex)
  (setq org-latex-compiler "lualatex")
  (setq org-export-with-toc nil)
  (setq org-latex-remove-logfiles nil)
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

          ("r" "Rendez-vous" entry
           (file+headline "~/Documents/Cerveau/inbox.org" "Rendez-vous")
           "* %^{Nom du rendez-vous}\nSCHEDULED: %^T"))))

;; org-superstar : remplace les astérisques bruts par des glyphes Unicode.
(use-package org-superstar
  :hook (org-mode . org-superstar-mode))

;; Repli visuel des longues lignes aux limites des mots, sans insérer de
;; vrais retours à la ligne dans le fichier (comme 'wrap' dans vim).
(add-hook 'org-mode-hook #'visual-line-mode)

;; Mode sans distraction : centre une colonne étroite et masque le
;; superflu (mode-line, fringes). Bascule manuelle via C-c w, pas de
;; hook automatique — on l'active seulement quand on veut écrire.
(use-package writeroom-mode
  :bind ("C-c w" . writeroom-mode)
  :custom
  (writeroom-width 70)                      ; largeur de la colonne
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
               (lambda (arg) (display-line-numbers-mode (if (> arg 0) -1 1)))))

;;; Ouverture de fichiers externes
;; openwith intercepte l'ouverture globalement (dired, find-file, liens
;; org) — plus large qu'org-file-apps qui ne couvre que les liens org.

(use-package openwith
  :config
  (setq openwith-associations
        '(("\\.pdf\\'" "zathura" (file))
          ("\\.\\(ods\\|odt\\|odp\\|docx\\|xlsx\\|pptx\\)\\'" "libreoffice" (file))))
  (openwith-mode 1))

;;; Langages additionnels
;; Org et Elisp sont colorisés nativement. Markdown et Nix ont besoin
;; d'un mode dédié, absent du vanilla par défaut.

(use-package markdown-mode
  :mode ("\\.md\\'" . markdown-mode))

(use-package nix-mode
  :mode ("\\.nix\\'" . nix-mode))

;;; init.el ends here
