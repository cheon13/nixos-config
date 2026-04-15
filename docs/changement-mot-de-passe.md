# Changement de mot de passe utilisateur (sops-nix)

## Prérequis

- Avoir accès à votre dépôt `.dotfiles`
- Avoir `sops` et `mkpasswd` disponibles sur votre machine

---

## Procédure

### 1. Générer le nouveau hash

```bash
mkpasswd -m sha-512
```

Entrez votre nouveau mot de passe quand demandé. Copiez le hash `$6$...` obtenu.

### 2. Éditer le fichier de secrets

```bash
sops secrets/common/secrets.yaml
```

Remplacez l'ancien hash par le nouveau :

```yaml
user_password: '$6$rounds=656000$votre_nouveau_hash_ici'
```

Sauvegardez et quittez — sops rechiffre automatiquement.

### 3. Déployer sur toutes les machines

**Sur portable (localement) :**
```bash
sudo nixos-rebuild switch --flake .#portable
```

**Sur les autres machines (à distance) :**
```bash
nixos-rebuild switch --flake .#serveur --target-host cheon@serveur --use-remote-sudo
nixos-rebuild switch --flake .#pomme --target-host cheon@pomme --use-remote-sudo
```

### 4. Valider le changement

Connectez-vous sur une console virtuelle (`Ctrl+Alt+F2`) avec le nouveau mot de passe pour confirmer que tout fonctionne.

### 5. Commiter

```bash
git commit -am "secret: mise à jour mot de passe cheon"
git push
```

---

## Notes

- Le fichier `secrets/common/secrets.yaml` est chiffré — vous pouvez le commiter en toute sécurité.
- Un seul changement met à jour le mot de passe sur **toutes vos machines** simultanément.
- Ne partagez jamais le hash en clair en dehors de `sops`.
