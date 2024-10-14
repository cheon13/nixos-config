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
building the system configuration...
error: builder for '/nix/store/ccyk309v0pxx26i2v4l8njslzx4c2qa3-dwl-0.7.drv' failed with exit code 2;
       last 10 log lines:
       > gcc  `pkg-config --cflags wlroots wayland-server xkbcommon libinput "xcb xcb-icccm"` -I. -DWLR_USE_UNSTABLE -D_POSIX_C_SOURCE=200809L  -DVERSION=\"`git describe --tags --dirty 2>/dev/null || echo 0.6`\" "-DXWAYLAND" -g -pedantic -Wall -Wextra -Wdeclaration-after-statement  -Wno-unused-parameter -Wshadow -Wunused-macros -Werror=strict-prototypes  -Werror=implicit -Werror=return-type -Werror=incompatible-pointer-types  -Wfloat-conversion -O1 -o dwl.o -c dwl.c
       > Package wlroots was not found in the pkg-config search path.
       > Perhaps you should add the directory containing `wlroots.pc'
       > to the PKG_CONFIG_PATH environment variable
       > No package 'wlroots' found
       > dwl.c:15:10: fatal error: wlr/backend.h: No such file or directory
       >    15 | #include <wlr/backend.h>
       >       |          ^~~~~~~~~~~~~~~
       > compilation terminated.
       > make: *** [Makefile:78: dwl.o] Error 1
       For full logs, run 'nix log /nix/store/ccyk309v0pxx26i2v4l8njslzx4c2qa3-dwl-0.7.drv'.
error: 1 dependencies of derivation '/nix/store/g6wnyv1i5ybsaapkqdaz1kg68kjvi3yb-system-path.drv' failed to build
error: 1 dependencies of derivation '/nix/store/vxwwqjwi2xb1635n64v5s8g2zil2j6fx-nixos-system-serveur-24.11.20241009.5633bcf.drv' failed to build
