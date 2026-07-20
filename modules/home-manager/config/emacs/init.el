;; -*- lexical-binding: t; -*-
;;; init.el --- Bootstrap literate config -*- lexical-binding: t; -*-
;;
;; Ce fichier ne contient aucune configuration. Tout le contenu réel
;; vit dans config.org (texte explicatif + blocs de code Elisp).
;;
;; Au démarrage : si config.org est plus récent que config.el (ou si
;; config.el n'existe pas encore), on retangle. Sinon, on charge
;; directement le .el déjà généré — pas de coût org-mode à chaque
;; lancement.

(defvar my/config-org (expand-file-name "config.org" user-emacs-directory))
(defvar my/config-el  (expand-file-name "config.el"  user-emacs-directory))

(when (or (not (file-exists-p my/config-el))
          (file-newer-than-file-p my/config-org my/config-el))
  (require 'org)
  (org-babel-tangle-file my/config-org my/config-el))

(load my/config-el)

;;; init.el ends here
