;;; init.el --- Configuration Emacs vanilla -*- lexical-binding: t; -*-
;;
;; Config vanilla construite par étapes en remplacement de Doom Emacs.
;; Les commentaires expliquent le *pourquoi* des choix, pour pouvoir y
;; revenir dans 6 mois sans redécouvrir le raisonnement.

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

;;; Page d'accueil (index.org)
;; Plutôt qu'un dashboard séparé, index.org à la racine d'org-directory
;; joue ce rôle. Emacs s'ouvre dessus, et C-c i y ramène de n'importe où.

(defvar my/index-file "~/Documents/Cerveau/index.org")

(setq initial-buffer-choice my/index-file)

(global-set-key (kbd "C-c i") (lambda () (interactive) (find-file my/index-file)))

;;; Thème
;; doom-themes fonctionne indépendamment du framework Doom — juste une
;; collection de thèmes. doom-themes-org-config harmonise la
;; fontification native d'org (blocs de code, citations) avec le thème.

(use-package doom-themes
  :config
  (load-theme 'doom-one t)
  (doom-themes-org-config))

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

;; Police : Adwaita Mono à 18pt (chasse fixe — important pour l'alignement
;; des tableaux org et du code). Ajustement à la volée : C-x C-+, C-x C--.
(set-face-attribute 'default nil :font "Adwaita Mono-18")
(add-to-list 'default-frame-alist '(font . "Adwaita Mono-18"))

;; Sauvegardes regroupées dans un sous-répertoire plutôt qu'éparpillées.
;; Création automatique des dossiers pour ne pas dépendre d'une étape
;; manuelle au premier lancement sur une nouvelle machine.
(let ((backup-dir (locate-user-emacs-file "backups"))
      (autosave-dir (locate-user-emacs-file "autosaves/")))
  (make-directory backup-dir t)
  (make-directory autosave-dir t)
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,autosave-dir t))))

;;; Evil-mode — scopé à l'édition
;; Contrairement à Doom qui active evil partout, evil ne s'applique qu'aux
;; buffers d'édition. Les interfaces de « gestion » (dired, magit, listes…)
;; gardent leurs raccourcis natifs Emacs.

(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil     ; laisse evil-collection gérer l'intégration
        evil-undo-system 'undo-redo
        evil-want-C-u-scroll t)      ; C-u pour scroller (comportement vim classique)
  :config
  (evil-mode 1)
  ;; Modes « gestion/listing » à garder en bindings natifs Emacs.
  (dolist (mode '(dired-mode
                  org-agenda-mode
                  magit-status-mode
                  magit-log-mode
                  magit-diff-mode
                  ibuffer-mode
                  package-menu-mode
                  help-mode
                  Info-mode
                  Custom-mode
                  proced-mode))
    (evil-set-initial-state mode 'emacs)))

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
  :bind (("C-x b" . consult-buffer)
         ("M-y"   . consult-yank-pop)))

;;; Projets (projectile)
;; Détection automatique des projets (racine via .git…). Un projet est
;; enregistré dès qu'un fichier y est ouvert. Chargé au démarrage
;; (:demand) car utilisé par le template de capture « p » plus bas.

(use-package projectile
  :demand t
  :bind-keymap ("C-c p" . projectile-command-map)
  :config
  (projectile-mode 1))

;;; Magit
;; C-x g pour ouvrir le statut du dépôt. Les modes magit sont déjà dans
;; la liste des exceptions evil (bindings natifs Emacs/magit).

(use-package magit
  :bind ("C-x g" . magit-status))

;;; Org-mode
;; Outil principal, chargé directement au démarrage (:demand) plutôt
;; qu'en lazy-loading.

(use-package org
  :ensure nil   ; built-in, pas besoin de le télécharger
  :demand t     ; chargé directement au démarrage, pas en lazy
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture))
  :config
  (setq org-directory "~/Documents/Cerveau/")

  (setq org-agenda-files
        (append
         ;; (directory-files-recursively "~/Documents/Cerveau/Projets/" "\\.org$")
         (directory-files-recursively "~/Documents/Cerveau/Aires/" "\\.org$")
         '("~/Documents/Cerveau/")))

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
           "* %?\n  %U")))

  ;; Fix conflit evil/org : en mode normal evil, TAB est bindé à
  ;; evil-jump-forward, ce qui masque org-cycle. Rebind explicite.
  (evil-define-key 'normal org-mode-map (kbd "TAB") #'org-cycle))

;; org-superstar : remplace les astérisques bruts par des glyphes Unicode.
(use-package org-superstar
  :hook (org-mode . org-superstar-mode))

;;; Ouverture de fichiers externes
;; openwith intercepte l'ouverture globalement (dired, find-file, liens
;; org) — plus large qu'org-file-apps qui ne couvre que les liens org.

(use-package openwith
  :config
  (setq openwith-associations
        '(("\\.pdf\\'" "zathura" (file))
          ("\\.\\(ods\\|odt\\|odp\\)\\'" "libreoffice" (file))))
  (openwith-mode 1))

;;; Langages additionnels
;; Org et Elisp sont colorisés nativement. Markdown et Nix ont besoin
;; d'un mode dédié, absent du vanilla par défaut.

(use-package markdown-mode
  :mode ("\\.md\\'" . markdown-mode))

(use-package nix-mode
  :mode ("\\.nix\\'" . nix-mode))

;;; init.el ends here
