# default.nix pour nixos

{ config, pkgs, ... }:

{
  imports = [
    ./wayland.nix
    ./syncthing.nix
    ./nixvim.nix
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  #services.xserver.windowManager.dwm.enable = true;
  #services.xserver.windowManager.dwm.package = pkgs.dwm.overrideAttrs {
  #  src = ./dwm;
  #};
  services.xserver.xkb = {
    layout = "fr";
    variant = "ergol";
    #layout = "ca";
    #variant = "fr";
    #options = "caps:swapescape";
    model = "pc101";
  };
  #programs.hyprland.enable = true;
  #programs.sway.enable = true;
  programs.river.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  
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

  hardware.keyboard.zsa.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_CA.UTF-8";

  # Configure console keymap
  console.useXkbConfig = true;
  #console.keyMap = "cf";
  console.font = "sun12x22";
  # Pour échanger Capslock et Escape
  #services.interception-tools = {
  #  enable = true;
  #  plugins = with pkgs; [
  #    interception-tools-plugins.caps2esc
  #  ];
  #  udevmonConfig = ''
  #    - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc -m 0 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
  #      DEVICE:
  #        EVENTS:
  #          EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
  #  '';
  #};
  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        # devices = [
        #   "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
        #   "/dev/input/by-id/usb-Keychron_Keychron_K2-event-kbd"
        #   "/dev/input/by-path/pci-0000:00:14.0-usb-0:9:1.1-event-kbd"
        #   "/dev/input/by-path/pci-0000:00:14.0-usbv2-0:9:1.1-event-kbd"
        #   "/dev/input/by-id/usb-Logitech_USB_Receiver-if01-event-kbd"
        # ];
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defsrc
           esc caps h j k l
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
          )

          (deflayer base
           caps esc _ _ _ _
           @spc 
          )

          (deflayer navnum
           _ _ @h @j @k @l
           _
          )
        '';
      };
    };
  };
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
    pulseaudio ## pour avoir le logiciel pactl qui permet de contrôler le son en ligne de commande.
    (st.overrideAttrs (oldAttrs: rec {
      src = ./st;
    }))
    dmenu
    dmenu-wayland # pour permettre d'utiliser dmenu et passmenu dans wayland
    xclip
    nitrogen
    wlr-randr
    wlopm
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
    font-awesome
    # fonts compatible avec Microsoft Arial, Courrier New et Times New Roman
    liberation_ttf
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

}
