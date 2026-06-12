
{ ... }: {

  # Le service kanata quitte parfois sur "failed poll: EINTR" (interruption
  # système). Le module NixOS fixe Restart=no, donc le service reste mort
  # jusqu'à un redémarrage manuel. On force le redémarrage automatique pour
  # qu'il se rétablisse seul.
  systemd.services."kanata-internalKeyboard".serviceConfig = {
    Restart = "always";
    RestartSec = 3;
  };

  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
         #devices = [
         #  "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
         #  "/dev/input/by-id/usb-Keychron_Keychron_K2-event-kbd"
         #  "/dev/input/by-path/pci-0000:00:14.0-usb-0:9:1.1-event-kbd"
         #  "/dev/input/by-path/pci-0000:00:14.0-usbv2-0:9:1.1-event-kbd"
         #  "/dev/input/by-id/usb-Logitech_USB_Receiver-if01-event-kbd"
         #  "/dev/input/event15"
         #];
        # Le MX Keys Mini est connecté en Bluetooth : pas de chemin stable
        # dans /dev/input/by-id, et son numéro d'event change. On le capture
        # donc par son nom plutôt que par un chemin (voir devices dans
        # configuration.nix, désormais vide).
        extraDefCfg = ''
          process-unmapped-keys yes
          linux-dev-names-include ("MX Keys Mini Keyboard")
        '';
        config = ''
          (defsrc
           esc caps h j k l
           < z            /
           spc rctrl
          )

          (defvar
           tap-time 200
           hold-time 250
          )

          (defalias
           spc (tap-hold $tap-time $hold-time spc (layer-toggle navnum))
           ;; pour le remap de hjkl dand ergol-l pour faciliter la navigation vim
           ;; réf : le site de kanata et https://shom.dev/start/using-kanata-to-remap-any-keyboard/
           h left 
           j down
           k up
           l rght
           z (tap-hold $tap-time $hold-time z lctrl) 
           / (tap-hold $tap-time $hold-time / rctrl)
           < (tap-hold $tap-time $hold-time < lshift)
          )

          (deflayer base
           caps esc _ _ _ _
           @< @z          @/
           @spc rmeta
          )

          (deflayer navnum
           _ _ @h @j @k @l 
           _ _          _
           _ _
          )
        '';
      };
    };
  };
}
