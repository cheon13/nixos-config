# configuration.nix

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos
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

  # Service de music streaming
  services.navidrome = {
    enable = true;
    openFirewall = true;
    settings = {
      Address = "10.0.0.200";
      Port = 4533;
      MusicFolder = "/var/Navidrome-music";
      EnableSharing = true;
    };
  };

  # Installation de gnugp avec une configuration de base
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };

  system.stateVersion = "23.05"; # Did you read the comment?

}
