# Notes de l'update 

lun 14 oct 2024 14:00:07 EDT

## commandes exécutées

### Update flake.lock
	nix flake update
#### Apply the updates
 sudo nixos-rebuild switch --flake ~/.dotfiles

## Message reçus

       error:
       Failed assertions:
       - The option definition `sound' in `/nix/store/vdgw6dv3dm9fkfm8hy74xlspinsrag07-source/hotes/serveur/configuration.nix' no longer has any effect; please remove it.
       The option was heavily overloaded and can be removed from most configurations.

       - The option definition `hardware.opengl.driSupport' in `/nix/store/vdgw6dv3dm9fkfm8hy74xlspinsrag07-source/modules/nixos/wayland.nix' no longer has any effect; please remove it.
       The setting can be removed.

       warning: Git tree '/home/cheon/.dotfiles' is dirty
       building the system configuration...
       warning: Git tree '/home/cheon/.dotfiles' is dirty
       trace: evaluation warning: taskwarrior was replaced by taskwarrior3, 
       which requires manual transition from taskwarrior 2.6, 
       read upstream's docs: https://taskwarrior.org/docs/upgrade-3/
       trace: evaluation warning: The option `hardware.opengl.enable' 
       defined in `/nix/store/18r3viilkdy55d1lhnili260a1z5r74i-source/modules/nixos/wayland.nix' 
       has been renamed to `hardware.graphics.enable'.
