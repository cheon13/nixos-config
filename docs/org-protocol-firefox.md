# org-protocol avec Firefox

Capturer une page (ou une sélection) depuis Firefox directement dans
`~/Documents/Cerveau/inbox.org`.

## Ce qui est déjà déclaré

| Élément | Où |
|---|---|
| Templates de capture `L` et `w`, chargement d'`org-protocol` | `modules/home-manager/config/emacs/init.el` |
| Script `org-protocol-capture` + desktop entry + association MIME | `modules/home-manager/emacs.nix` |

Chaîne complète :

```
bookmarklet Firefox
  → org-protocol://capture?template=L&url=…&title=…&body=…
  → Firefox délègue le schéma inconnu au bureau
  → mimeapps.list : x-scheme-handler/org-protocol → org-protocol.desktop
  → emacsclient -c (frame « org-capture »)
  → handler org-protocol → org-capture
```

Appliquer :

```bash
sudo nixos-rebuild switch --flake ~/.dotfiles
systemctl --user restart emacs   # recharge init.el
```

## Ce qui reste à faire à la main dans Firefox

Les marque-pages vivent dans le profil Firefox (`~/.mozilla/firefox/…`), hors
du dépôt : ces deux étapes sont manuelles, une fois par machine.

### 1. Autoriser la délégation du schéma

`about:config` → `network.protocol-handler.expose.org-protocol` → **Booléen**,
valeur **false**. Firefox demande alors au bureau d'ouvrir ces URL au lieu de
tenter de les traiter lui-même.

Au premier usage, une boîte de dialogue propose l'application : choisir
« org-protocol » et cocher « Toujours utiliser cette application ».

### 2. Créer les deux marque-pages

Barre personnelle → clic droit → « Ajouter un marque-page », avec l'URL
ci-dessous (le nom est libre).

**Capturer le lien** — enregistre titre + URL sans rien demander
(template `L`, `:immediate-finish`) :

```javascript
javascript:location.href='org-protocol://capture?template=L&url='+encodeURIComponent(location.href)+'&title='+encodeURIComponent(document.title)
```

**Capturer la sélection** — ouvre le tampon de capture avec le texte
sélectionné dans un bloc `quote` (template `w`) :

```javascript
javascript:location.href='org-protocol://capture?template=w&url='+encodeURIComponent(location.href)+'&title='+encodeURIComponent(document.title)+'&body='+encodeURIComponent(window.getSelection())
```

Une frame Emacs dédiée s'ouvre, et se referme d'elle-même une fois la capture
validée (`C-c C-c`) ou abandonnée (`C-c C-k`).

## Diagnostic

- **Firefox ouvre une recherche au lieu du dialogue** : le préf de l'étape 1
  est absent ou à `true`.
- **Emacs ouvre un fichier nommé `org-protocol://capture?…`** : `org-protocol`
  n'était pas chargé. Il l'est via un `run-with-idle-timer` au démarrage du
  daemon ; vérifier avec `emacsclient -e '(featurep (quote org-protocol))'`.
- **Rien ne se passe** : tester la chaîne sans Firefox —
  `xdg-open "org-protocol://capture?template=L&url=https://example.com&title=Test"`.
- **Le lien contient `%20` ou des caractères cassés** : le bookmarklet doit
  encoder chaque paramètre avec `encodeURIComponent`.
