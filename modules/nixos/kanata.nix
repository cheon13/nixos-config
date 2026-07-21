{ ... }: {

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
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defsrc
                              y u i o           
           esc caps  a s d f  h j k l ;
           < z            /
           spc menu
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
           hr-a (tap-hold $tap-time $hold-time a lmet)
           hr-s (tap-hold $tap-time $hold-time s lalt)
           hr-d (tap-hold $tap-time $hold-time d lctrl)
           hr-f (tap-hold $tap-time $hold-time f lshift)
           hr-j (tap-hold $tap-time $hold-time j rshift)
           hr-k (tap-hold $tap-time $hold-time k rctrl)
           hr-l (tap-hold $tap-time $hold-time l lalt)
           hr-sc (tap-hold $tap-time $hold-time ; rmet)
           z (tap-hold $tap-time $hold-time z lctrl) 
           / (tap-hold $tap-time $hold-time / rctrl)
           < (tap-hold $tap-time $hold-time < lshift)
          )

          (deflayer base
                                              y u i o     
           caps esc  @hr-a @hr-s @hr-d @hr-f  _ @hr-j @hr-k @hr-l @hr-sc

           @< @z          @/
           @spc rmeta
          )

          (deflayer navnum
                         @y @u @i @o  
           _ _  _ _ _ _  @h @j @k @l _
           _ _          _
           _ _
          )
        '';
      };
    };
  };
}
