# configuration.nix pour portable

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos
    ../../modules/nixos/gnome.nix
  ];
  
  services.displayManager.defaultSession = "river";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "portable"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable CUPS to print documents.
  services.printing.enable = true;

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

  system.stateVersion = "24.05"; # Did you read the comment?

}
