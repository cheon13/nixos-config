❯ ./build.sh 'changer firefox-wayland à firefox'
[main fc4a9e6] changer firefox-wayland à firefox
 4 files changed, 4 insertions(+), 4 deletions(-)
[sudo] Mot de passe de cheon : 
building the system configuration...
evaluation warning: cheon profile: The option `programs.git.userEmail' defined in `/nix/store/nsmdykggpak46zigpcqk94jb4ihvxj3h-source/modules/home-manager' has been renamed to `programs.git.settings.user.email'.
evaluation warning: cheon profile: The option `programs.git.userName' defined in `/nix/store/nsmdykggpak46zigpcqk94jb4ihvxj3h-source/modules/home-manager' has been renamed to `programs.git.settings.user.name'.
evaluation warning: cheon profile: The option `programs.git.extraConfig' defined in `/nix/store/nsmdykggpak46zigpcqk94jb4ihvxj3h-source/modules/home-manager' has been renamed to `programs.git.settings'.
evaluation warning: cheon profile: You are using

                      Home Manager version 26.05 and
                      Nixpkgs version 25.11.

                    Using mismatched versions is likely to cause errors and unexpected
                    behavior. It is therefore highly recommended to use a release of Home
                    Manager that corresponds with your chosen release of Nixpkgs.

                    If you insist then you can disable this warning by adding

                      home.enableNixpkgsReleaseCheck = false;

                    to your configuration.
evaluation warning: A legacy Nextcloud install (from before NixOS 25.11) may be installed.

                    After nextcloud31 is installed successfully, you can safely upgrade
                    to 32. The latest version available is Nextcloud32.

                    Please note that Nextcloud doesn't support upgrades across multiple major versions
                    (i.e. an upgrade from 16 is possible to 17, but not 16 to 18).

                    The package can be upgraded by explicitly declaring the service-option
                    `services.nextcloud.package`.
error:
       … while calling the 'head' builtin
         at /nix/store/g02rq8ap30x3fp8zrz07ip5v1s0pzidn-source/lib/attrsets.nix:1696:13:
         1695|           if length values == 1 || pred here (elemAt values 1) (head values) then
         1696|             head values
             |             ^
         1697|           else

       … while evaluating the attribute 'value'
         at /nix/store/g02rq8ap30x3fp8zrz07ip5v1s0pzidn-source/lib/modules.nix:1118:7:
         1117|     // {
         1118|       value = addErrorContext "while evaluating the option `${showOption loc}':" value;
             |       ^
         1119|       inherit (res.defsFinal') highestPrio;

       … while evaluating the option `system.build.toplevel':

       … while evaluating definitions from `/nix/store/g02rq8ap30x3fp8zrz07ip5v1s0pzidn-source/nixos/modules/system/activation/top-level.nix':

       … while evaluating the option `system.systemBuilderArgs':

       … while evaluating definitions from `/nix/store/g02rq8ap30x3fp8zrz07ip5v1s0pzidn-source/nixos/modules/system/activation/activatable-system.nix':

       … while evaluating the option `system.activationScripts.etc.text':

       … while evaluating definitions from `/nix/store/g02rq8ap30x3fp8zrz07ip5v1s0pzidn-source/nixos/modules/system/etc/etc-activation.nix':

       … while evaluating definitions from `/nix/store/g02rq8ap30x3fp8zrz07ip5v1s0pzidn-source/nixos/modules/system/etc/etc.nix':

       … while evaluating the option `environment.etc."X11/xinit/xserverrc".source':

       … while evaluating the option `services.xserver.displayManager.xserverArgs':

       … while evaluating definitions from `/nix/store/g02rq8ap30x3fp8zrz07ip5v1s0pzidn-source/nixos/modules/services/x11/xserver.nix':

       … while evaluating the option `fonts.packages':

       … while evaluating definitions from `/nix/store/nsmdykggpak46zigpcqk94jb4ihvxj3h-source/modules/nixos':

       (stack trace truncated; use '--show-trace' to show the full, detailed trace)

       error: 'noto-fonts-emoji' has been renamed to/replaced by 'noto-fonts-color-emoji'
Command 'nix --extra-experimental-features 'nix-command flakes' build --print-out-paths '/home/cheon/.dotfiles#nixosConfigurations."serveur".config.system.build.toplevel' --no-link' returned non-zero exit status 1.#
