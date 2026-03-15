# configuration.nix pour pomme

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    #/home/cheon/.dotfiles/hotes/pomme/hardware-configuration.nix
    ./hardware-configuration.nix
    ./kanata.nix
    ../../modules/nixos
    ../../modules/nixos/gnome.nix
    ../../modules/nixos/syncthing.nix
  ];
  
 # services.displayManager.defaultSession = "river";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # load broadcom wireless driver and front camera du macbook air 2014
  boot.kernelModules = [ "wl" "facetimehd" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ broadcom_sta facetimehd ];
  
  # blacklist similar modules to avoid collision
  boot.blacklistedKernelModules = [ "b43" "bcma" ];
  
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-6.12.69"
  ];
  # Extraire et installer le firmware nécessaire pour la caméra du macbook air 2014
  hardware.facetimehd.enable = true;

  networking.hostName = "pomme"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # pour permettre les imprimantes autodécouvertes (IPP Everywhere)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Installation de gnugp avec une configuration de base
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
    #pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [
    slstatus 
  ];
  system.stateVersion = "25.11"; 

}
