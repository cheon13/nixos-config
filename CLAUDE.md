# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Contexte

Configuration NixOS déclarative pour 3 machines : `portable`, `serveur`, `pomme`. Géré avec Nix Flakes, Home Manager, SOPS-nix et Nixvim. La langue de travail est le **français** (commentaires, documentation, messages de commit).

## Commandes

```bash
# Build + commit (machine locale)
./build.sh "message de commit"

# Rebuild sans commit
sudo nixos-rebuild switch --flake ~/.dotfiles

# Rebuild d'une machine spécifique
sudo nixos-rebuild switch --flake .#portable
sudo nixos-rebuild switch --flake .#serveur
sudo nixos-rebuild switch --flake .#pomme

# Déployer à distance
nixos-rebuild switch --flake .#serveur --target-host cheon@serveur --sudo
nixos-rebuild switch --flake .#pomme --target-host cheon@pomme --sudo

# Tester sans appliquer
nixos-rebuild build --flake .#portable

# Mise à jour mensuelle (flake update + rebuild + nettoyage)
./mise-a-jour.sh
```

## Architecture

```
flake.nix                  # Point d'entrée : définit les 3 nixosConfigurations
hotes/<machine>/
  configuration.nix        # Config système NixOS de la machine
  home.nix                 # Config utilisateur Home Manager
modules/nixos/             # Modules système partagés entre les machines
modules/home-manager/      # Modules utilisateur partagés
secrets/
  common/secrets.yaml      # Secrets SOPS chiffrés (mot de passe utilisateur, etc.)
```

Le `flake.nix` utilise une fonction `mkHost` qui assemble chaque machine à partir de son dossier `hotes/<machine>/` en y injectant les modules sops-nix, home-manager et nixvim.

## Secrets (SOPS-nix)

Les secrets sont chiffrés avec des clés age définies dans `.sops.yaml`. Les clés publiques sont dans `clés-publiques.md`.

```bash
# Modifier un secret
sops secrets/common/secrets.yaml

# Changer le mot de passe utilisateur
mkpasswd -m sha-512   # générer le hash, puis l'insérer via sops
```

Voir `docs/changement-mot-de-passe.md` pour la procédure complète.

## Règles importantes

- Toujours utiliser `nixos-rebuild build` pour valider avant de proposer un `switch`
- Ne jamais modifier `flake.lock` manuellement — c'est le rôle de `nix flake update`
- Les secrets ne doivent jamais apparaître en clair — tout passe par `sops`
- `nixpkgs-unstable` est disponible via `pkgs-unstable` pour les paquets qui en ont besoin (ex: claude-code)
