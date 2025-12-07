
{self, pkgs, ...}: {

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
           esc caps h j k l
           z              /
           spc
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
          )

          (deflayer base
           caps esc _ _ _ _
           @z             @/
           @spc 
          )

          (deflayer navnum
           _ _ @h @j @k @l 
           _            _
           _
          )
        '';
      };
    };
  };
}
