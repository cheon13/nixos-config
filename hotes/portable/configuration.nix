# configuration.nix

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos/wayland.nix
    ../../modules/nixos/gnome.nix
    #../../modules/nixos/gdm.nix
    #../../modules/nixos/sddm.nix
    ../../modules/nixos/syncthing.nix
    ../../modules/nixos/nixvim.nix
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.dwm.enable = true;
  services.xserver.windowManager.dwm.package = pkgs.dwm.overrideAttrs {
    src = ../../modules/nixos/dwm;
  };
  services.xserver.xkb = {
    layout = "ca";
    # variant = "fr";
    #options = "caps:swapescape";
  };
  services.displayManager.defaultSession = null;
  programs.hyprland.enable = true;
  programs.sway.enable = true;
  programs.river.enable = true;
  #programs.nixvim.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "portable"; # Define your hostname.
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
    alias serveur='ssh serveur'
  '';

  # Enabling bluetooth
  hardware.bluetooth.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_CA.UTF-8";

  # Configure console keymap
  console.keyMap = "cf";
  console.font = "sun12x22";
  # Pour échanger Capslock et Escape
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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  # sound.enable = true; # option definition 'sound' no longer has any effect.
  services.pulseaudio.enable = false;
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

  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Installation de gnugp avec une configuration de base
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cheon = {
    isNormalUser = true;
    description = "Christian Héon";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
    ];
    packages = with pkgs; [
      firefox
      kitty
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    lua-language-server
    git
    gh # github CLI pour faciliter l'authentification avec github.
    gnupg
    pinentry
    pinentry-curses
    pass
    rclone
    xdg-utils
    pulseaudio # # pour avoir le logiciel pactl qui permet de contrôler le son en ligne de commande.
    (st.overrideAttrs (oldAttrs: rec {
      src = ../../modules/nixos/st;
    }))
    (slstatus.overrideAttrs (oldAttrs: rec {
      src = ./slstatus;
    }))
    dmenu
    xclip
    nitrogen
    #(dwl.overrideAttrs (oldAttrs: rec {
    #  src = ../../modules/nixos/dwl;
    #}))
    wlr-randr
    wlopm
    #widevine-cdm
    #nodePackages.nodejs  # pour utiliser le plugin coc.nvim
    #ltex-ls              # pour utiliser coc-ltex
  ];

  # Installation d'un package pour ricer nixos
  #stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

  # Installation de fonts supplémentaires
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    nerd-fonts.noto
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    #nerdfonts
    #powerline-fonts # pour utiliser airline
    font-awesome
  ];

  # installation de nodejs pour utiliser le plugin coc-nvim
  #environment.systemPackages = [
  #  pkgs.nodePackages.nodejs
  #];

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
  # this value at the release version of the firspath/to/dwm/source/treet install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
