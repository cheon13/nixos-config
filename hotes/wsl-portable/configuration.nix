# Edit this configuration file to define what should be installed on your system. Help is 
# available in the configuration.nix(5) man page, on https://search.nixos.org/options and in 
# the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository: 
# https://github.com/nix-community/NixOS-WSL
inputs:
{ config, lib, pkgs, inputs, ... }:

{ imports = [
    # include NixOS-WSL modules
    #<nixos-wsl/modules>
    ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  wsl.enable = true; wsl.defaultUser = "cheon"; wsl.wslConf.network.generateHosts = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "wsl-portable"; # Define your hostname.
  #networking.hostName = "DESKTOP-UEM9CA3"; # Define your hostname.

  # Ajout manuel au fichiers /etc/hosts
  networking.extraHosts = ''
    10.0.0.201 portable
    10.0.0.200 serveur
    10.0.0.202 phone
    10.0.0.203 tablette
  '';

  # Setting environment Variables for all users
  environment.sessionVariables = {
    EDITOR = "nvim";
  };

  environment.interactiveShellInit = ''
    alias phone='ssh u0_a450@phone -p8022'
    alias portable='ssh portable'
    alias serveur='ssh serveur'
  '';

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_CA.UTF-8";

  # Installation de gnugp avec une configuration de base
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cheon = {
    isNormalUser = true;
    description = "Christian Héon";
    # extraGroups = [ "networkmanager" "wheel" "audio"];
    packages = with pkgs; [
     # firefox
     neofetch
     zathura
     htop
    ];
  };

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  neovim
  git
  gh #github CLI pour faciliter l'authentification avec github.
  gnupg
  pinentry
  pinentry-curses
  pass
  rclone
  xdg-utils
  ];

  # Installation de fonts supplémentaires
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    jetbrains-mono
    nerdfonts
    powerline-fonts # pour utiliser airline
    font-awesome
  ];
    
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  #services.openssh.enable = true;

  # This value determines the NixOS release from which the default settings for stateful data, 
  # like file locations and database versions on your system were taken. It's perfectly fine 
  # and recommended to leave this value at the release version of the first install of this 
  # system. Before changing this value read the documentation for this option (e.g. man 
  # configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
