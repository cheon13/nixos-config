# configuration.nix

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/nixos/syncthing.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 

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

  # Enable networking
  networking.networkmanager.enable = true;

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
  '';
  # Enabling bluetooth
  hardware.bluetooth.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_CA.UTF-8";

# # Service de synchronisation Syncthing
# services.syncthing = {
#   enable = true;
#   dataDir = "/home/cheon/Documents";
#   openDefaultPorts = true;
#   configDir = "/home/cheon/.config/syncthing";
#   user = "cheon";
#   #group = "users";
#   guiAddress = "127.0.0.1:8384";
#     overrideDevices = true;
#     overrideFolders = true;
#     settings.devices = {
#       "portable" = { id = "WOSHMB7-N5YIJTM-VLAPPHS-HUQS2QO-CEO67WO-MF4LJIW-4HGO563-LPEVCAZ"; };
#       "phone" = { id = "WNJ5NHU-FCEJGLJ-TBESUFK-XPMKGBN-H225KSH-JZB7XB5-FGAQUWH-4WXIVQF"; };
#       "DESKTOP-UEM9CA3" = { id = "FWKDNXG-UIMQA6F-FTBAGSP-VKD34DH-DFGQDWO-ZOPEKOJ-KV54A6J-IVU44AM"; };
#     };
#     settings.folders = {
#       "Cerveau" = { 
#         id = "mbh3e-b0zp2";
#         path = "/home/cheon/Documents/Cerveau"; 
#         devices = [ "portable" "phone" ]; 
#         versioning = { 
#           type = "simple"; 
#           params = { 
#             keep = "10"; 
#           }; 
#         }; 
#       };
#     };
# };

  # Wayland and Sway config
  ## Hardware Support for Wayland Sway

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
    };
  };
  ## XDG config for wayland 
  xdg = {
    portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };
  ## Allow swaylock to unlock the computer for us
  security.pam.services.swaylock = {
    text = "auth include login";
  };

  # Configure console keymap
  console.keyMap = "cf";
  console.font = "sun12x22";
  # Pour échager Capslock et Escape
  services.interception-tools = {
    enable = true;
    plugins = with pkgs; [
      interception-tools-plugins.caps2esc
    ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc -m 0 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };

  # Installation d'hyprland
  programs.hyprland.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

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
    extraGroups = [ "networkmanager" "wheel" "audio"];
    packages = with pkgs; [
      firefox
      kitty
    ];
  };

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  neovim
  git
  gh #github CLI pour faciliter l'authentification avec github.
  gnupg
  pinentry
  pinentry-curses
  pass
  rclone
  xdg-utils
  # Library nécessaire pour le plugin de taskwiki?
  #python310Packages.tasklib
  #python310Packages.six
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
    
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
