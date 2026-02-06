# configuration.nix pour portable

{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos
    ../../modules/nixos/gnome.nix
  ];
  
 # services.displayManager.defaultSession = "river";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "portable"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # pour permettre les imprimantes autodécouvertes (IPP Everywhere)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    # compilation de slstatus propre à portable
    (slstatus.overrideAttrs (oldAttrs: rec {
      src = ./slstatus;
    }))
  ];

  # Installation de gnugp avec une configuration de base
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
    #pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };

  # Configuration spécifique à portable 
  # La configuration générale se trouve dans modules/nixos/kanata.nix
  services.kanata = {
    keyboards = {
      internalKeyboard = {
         devices = [
           "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
           "/dev/input/by-id/usb-Keychron_Keychron_K2-event-kbd"
           #"/dev/input/by-path/pci-0000:00:14.0-usb-0:9:1.1-event-kbd"
           #"/dev/input/by-path/pci-0000:00:14.0-usbv2-0:9:1.1-event-kbd"
           #"/dev/input/by-id/usb-Logitech_USB_Receiver-if01-event-kbd"
           #"/dev/input/event15"
         ];
      };
    };
  };

  # Optimisation de la batterie pour le laptop
  services.tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  
          CPU_MIN_PERF_ON_AC = 0;
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MIN_PERF_ON_BAT = 0;
          CPU_MAX_PERF_ON_BAT = 20;
  
         #Optional helps save long term battery health
         START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
         STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
  
        };
  };

  system.stateVersion = "24.05"; # Did you read the comment?

}
