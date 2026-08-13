# configuration.nix

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./syncthing.nix
    ../../modules/nixos
    ./kanata.nix
    ./kmscon.nix
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
  #
  # pinentry-curses et non -gtk2 (contrairement à portable et pomme) :
  # serveur n'a pas de session graphique, une invite GTK n'a nulle part
  # où s'afficher et la saisie de phrase de passe échoue.
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    # Laissé à false volontairement : gpg-agent ne sert que les clés qu'on
    # lui confie explicitement par ssh-add, il ne lit pas ~/.ssh/id_ed25519.
    # Avec true, ssh retombait sur le fichier et redemandait la phrase de
    # passe à chaque connexion. On confie SSH à ssh-agent ci-dessous, et on
    # garde gpg-agent pour GPG seul. Les deux sont mutuellement exclusifs :
    # NixOS refuse enableSSHSupport et programs.ssh.startAgent ensemble.
    enableSSHSupport = false;
  };

  # Agent SSH classique. Sur portable et pomme, ce rôle est tenu par
  # gnome-keyring (via modules/nixos/gnome.nix) ; serveur étant sans
  # environnement de bureau, il faut le déclarer explicitement ici.
  programs.ssh = {
    startAgent = true;
    # ssh-agent démarre vide : sans ceci, il faudrait un ssh-add manuel
    # à chaque session. AddKeysToAgent confie la clé à l'agent lors de la
    # première utilisation, la phrase n'est donc demandée qu'une fois.
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };

  # Configuration spécifique à serveur
  # La configuration générale (dont le matching du clavier MX Keys Mini par
  # nom via linux-dev-names-include) se trouve dans ./kanata.nix.
  # On ne fixe aucun `devices` ici : le clavier est en Bluetooth et n'a pas
  # de chemin stable, kanata le détecte par son nom.

  system.stateVersion = "23.05"; # Did you read the comment?

}
