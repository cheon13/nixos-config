;;; early-init.el --- Optimisations de démarrage -*- lexical-binding: t; -*-
;;
;; Chargé par Emacs AVANT init.el, avant l'initialisation des paquets et
;; de l'UI — le meilleur endroit pour ce genre de réglage temporaire.

;; Seuil GC au maximum pendant tout le chargement (voir init.el pour la
;; restauration après coup) — évite les pauses de ramassage de mémoire
;; en boucle pendant le chargement massif d'Elisp (evil, doom-themes).
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Désactive temporairement les gestionnaires de noms de fichiers
;; (TRAMP, compression, etc.) pendant le chargement — chaque require/load
;; évite ainsi une vérification inutile contre ces gestionnaires.
(defvar my/file-name-handler-alist-backup file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Évite qu'Emacs redessine le cadre deux fois au démarrage (une fois
;; avec la taille par défaut, une fois avec la config chargée).
(setq frame-inhibit-implied-resize t)

;; package-initialize sera appelé explicitement dans init.el ; on évite
;; qu'Emacs le fasse une deuxième fois automatiquement avant init.el.
(setq package-enable-at-startup nil)
