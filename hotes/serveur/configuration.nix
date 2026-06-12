# configuration.nix

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./syncthing.nix
    ../../modules/nixos
    ./kanata.nix
    ../../modules/nixos/nextcloud
    ../../modules/nixos/navidrome.nix
    ../../modules/nixos/actualbudget.nix
    ../../modules/nixos/jellyfin.nix
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Ajout du disque externe pour les backup
  fileSystems."/mnt/backup" =
    { device = "/dev/disk/by-uuid/33a30ccc-46ef-4a3d-895a-31fd72e8f004";
      fsType = "ext4";
      options = [ "nofail,user" ];
    };

  networking.hostName = "serveur"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  environment.systemPackages = with pkgs; [
    # compilation de slstatus propre à serveur
    (slstatus.overrideAttrs (oldAttrs: rec {
      src = ./slstatus;
    }))
  ];

  # Installation de gnugp avec une configuration de base
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;
    #pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };

  # Configuration spécifique à serveur
  # La configuration générale se trouve dans modules/nixos/kanata.nix
  services.kanata = {
    keyboards = {
      internalKeyboard = {
         devices = [
           # Récepteur Logitech (clavier sans fil) — chemin stable via by-id.
           # Les 3 anciens chemins pointaient tous vers le même /dev/input/event0
           # et /dev/input/event15 n'existait pas : source des "removing kbd
           # device" et des plantages. On ne garde donc qu'un seul chemin stable.
           "/dev/input/by-id/usb-Logitech_USB_Receiver-if01-event-kbd"
         ];
      };
    };
  };

  system.stateVersion = "23.05"; # Did you read the comment?

}
