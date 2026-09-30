
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
                              y u i o           
           esc caps  a s d f  h j k l
                 <  z x c v    m , . /
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
           y home
           u pgdn
           i pgup
           o end
           ;; home row
           hr-z (tap-hold $tap-time $hold-time z lmet)
           hr-x (tap-hold $tap-time $hold-time x lalt)
           hr-c (tap-hold $tap-time $hold-time c lctrl)
           hr-f (tap-hold $tap-time $hold-time f lshift)
           hr-v (tap-hold $tap-time $hold-time v lshift)
           hr-j (tap-hold $tap-time $hold-time j rshift)
           hr-m (tap-hold $tap-time $hold-time m rshift)
           hr-comma (tap-hold $tap-time $hold-time , rctrl)
           hr-dot (tap-hold $tap-time $hold-time . lalt)
           / (tap-hold $tap-time $hold-time / rmet)
           < (tap-hold $tap-time $hold-time < lshift)
          )

          (deflayer base
                                                y     u     i         o     
           caps esc  _     _     _     @hr-f    _     @hr-j _         _  
                @<   @hr-z @hr-x @hr-c @hr-v          @hr-m @hr-comma @hr-dot @/
           @spc rmeta
          )

          (deflayer navnum
                         @y @u @i @o  
           _ _  _ _ _ _  @h @j @k @l _
             _  _ _ _ _  _  _  _   _
           _ _
          )
        '';
      };
    };
  };
}
