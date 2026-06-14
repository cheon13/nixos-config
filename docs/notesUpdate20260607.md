# Notes de l'update 

## Dimanche 07 juin 2026

## commandes exécutées

### Update flake.lock
	nix flake update
#### Apply the updates
 sudo nixos-rebuild switch --flake ~/.dotfiles

## Message reçus

❯ sudo nixos-rebuild switch --flake .#portable
[sudo] Mot de passe de cheon : 
building the system configuration...
evaluation warning: The `home-manager.users.cheon.programs.nixvim.nixpkgs.source` default value has been affected by your flake input `follows`.
                    Nixvim's inputs pin Nixpkgs to `6b316287bae2ee04c9b93c8c858d930fd07d7338`. Actual Nixpkgs is following `9b696460ac78b5ccfc17c854d8c976f20456e943`.
                    Please remove your `inputs.nixvim.inputs.nixpkgs.follows` or explicitly define `home-manager.users.cheon.programs.nixvim.nixpkgs.source` to suppress this warning.
evaluation warning: nixfmt-rfc-style is now the same as pkgs.nixfmt which should be used instead.
evaluation warning: cheon profile: The `home-manager.users.cheon.programs.nixvim.nixpkgs.source` default value has been affected by your flake input `follows`.
                    Nixvim's inputs pin Nixpkgs to `6b316287bae2ee04c9b93c8c858d930fd07d7338`. Actual Nixpkgs is following `9b696460ac78b5ccfc17c854d8c976f20456e943`.
                    Please remove your `inputs.nixvim.inputs.nixpkgs.follows` or explicitly define `home-manager.users.cheon.programs.nixvim.nixpkgs.source` to suppress this warning.
error: hash mismatch in fixed-output derivation '/nix/store/jzprcw0pzgxqmwip54lkvvhvwv2pigwr-source.drv':
         specified: sha256-r8hAUpSsr8zNm+av8Mu5oILaTfEsXEnJmkzRmvi9pF8=
            got:    sha256-l/PcQlCSQKr0aSfnPUwRf7rY6QAx9u5twYsSX72B4xI=
error: Cannot build '/nix/store/l2iihmg7l1qqjjk2ifxnswsaxz8dqqhx-vimplugin-claudecode-nvim.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/0n1s4dad3ms27slxgy95rfnwlw8qsihd-vimplugin-claudecode-nvim
error: Build failed due to failed dependency
error: Cannot build '/nix/store/1nxri18yciqfn5jj71a57jhcjl8zhphz-neovim-0.12.2.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/sb20if1lb8znz2fj4p1nairvj7vaxf4z-neovim-0.12.2
error: Cannot build '/nix/store/di3idnvwim71bnvcqd6lfigch8asdgdc-packdir-start.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/lid92fxbvzqzds2p6ghwp5z7q1dabwzh-packdir-start
error: Build failed due to failed dependency
error: Cannot build '/nix/store/7ffar328kqkwr8ny1ghimmzir5n8w486-nixvim.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/sxmf0gbkdskh0zk4ynhnh48zzpsrn3fd-nixvim
error: Build failed due to failed dependency
error: Cannot build '/nix/store/drjkyfbxjhwgwj8j6kb0m7csz9x7m5qc-home-manager-path.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/dls1izpghr4cdjnrd0yxgm6wyl51dy5c-home-manager-path
error: Build failed due to failed dependency
error: Cannot build '/nix/store/0101c7p1pwxvm89s6iyf7ajcm4xh4bw1-hm_fontconfigconf.d10hmfonts.conf.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/jhd15a1cibyhbkdj8xalciiryk8yfc29-hm_fontconfigconf.d10hmfonts.conf
error: Cannot build '/nix/store/zv8rgbr5zjkrw0pxraxmwnpqcg1akwp7-home-manager-generation.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/2fm16qdfblhjpv3ngzcbp310isnhwb80-home-manager-generation
error: Cannot build '/nix/store/q7zmlzk08a5byqpvsaignc593qk4gf6x-user-environment.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/4lagclj5nmk1jqh1rz9nlc7ngd32y5w1-user-environment
error: Build failed due to failed dependency
error: Build failed due to failed dependency
error: Cannot build '/nix/store/bdcplpkrqmsfrs53bsjxmpakpia6al8j-etc.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/8y19nc7alzrsj3x8n8sqa1nwik8nrads-etc
error: Cannot build '/nix/store/q4iqf6qi2h3xkgy9qxbxi9ycbd3las0w-unit-home-manager-cheon.service.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/wl18yd1zgwa6wsnkz1654x4086fw1194-unit-home-manager-cheon.service
error: Build failed due to failed dependency
error: Cannot build '/nix/store/nz653dmiy7b4jp8rjfgdyakxa3l9rs0k-activate.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/cnk5wk8c1bcvnb6liq7w70jlb1mif6wq-activate
error: Cannot build '/nix/store/y2hml2srxpf9sqmy3wk3x4w509kv9pwh-nixos-system-portable-26.05.20260606.9b69646.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/c7f8l12h8wig1j3sk4cfnf15drqz3yg2-nixos-system-portable-26.05.20260606.9b69646
[8/241/387 built (1 failed), 16/1820/2043 copied (9.1/12.2 GiB), 2.5/3.5 GiB DL] building unit-dbus.socket
error: Build failed due to failed dependency
Command 'nix --extra-experimental-features 'nix-command flakes' build --print-out-paths '.#nixosConfigurations."portable".config.system.build.toplevel' --no-link' returned non-zero exit status 1.
