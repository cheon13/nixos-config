# default.nix pour nixos

{ config, pkgs, pkgs-unstable, claudePkg, ... }:

{
  imports = [
    ./wayland.nix
    #./syncthing.nix
    #./nixvim.nix
    #./kanata.nix
    ./sops.nix
    ./dwl.nix
  ];

  #services.udisks2.enable = true; # pour le montage automatique des disques USB

  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.xkb = {
    layout = "fr";
    variant = "ergol";
    #layout = "ca";
    #variant = "fr";
    #options = "caps:swapescape";
    model = "pc101";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.trusted-users = [
    "cheon"
  ];
  
  # Enable networking
  networking.networkmanager.enable = true;

  # Ajout manuel au fichiers /etc/hosts
  networking.extraHosts = ''
    10.0.0.200 serveur
    10.0.0.201 portable
    10.0.0.202 phone
    10.0.0.203 tablette
    10.0.0.204 pomme
    10.0.0.205 mammouth
  '';

  # Setting environment Variables for all users
  #
  # SOURCE UNIQUE de l'éditeur par défaut pour les 3 machines.
  # `-t` ouvre un frame dans le terminal courant ; `-a emacs` démarre un Emacs
  # autonome si le daemon n'est pas (encore) disponible.
  # Ne PAS redéfinir EDITOR côté Home Manager : `services.emacs.defaultEditor`
  # y écrirait un wrapper `emacsclient --create-frame` (fenêtre graphique) dans
  # ~/.profile, qui prendrait le dessus dans les shells de login — cf.
  # modules/home-manager/emacs.nix.
  environment.sessionVariables = {
    EDITOR = "emacsclient -t -a emacs";
    VISUAL = "emacsclient -t -a emacs";  # certains outils préfèrent VISUAL
  };

  environment.interactiveShellInit = ''
    alias phone='ssh u0_a450@phone -p8022'
    alias portable='ssh portable'
    alias serveur='ssh serveur'
    alias pomme='ssh pomme'
  '';

  # Enabling bluetooth
  hardware.bluetooth.enable = true;

  hardware.keyboard.zsa.enable = true;

  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  hardware.sane.enable = true; # enables support for SANE scanners
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];

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
    hashedPasswordFile = config.sops.secrets.user_password.path;  # nouveau

    # Clés SSH autorisées, déclarées ici plutôt que posées à la main dans
    # ~/.ssh/authorized_keys sur chaque machine : c'est ce qui rend
    # `nixos-rebuild --target-host` non interactif et reproductible. Sans
    # ça, les accès dérivent machine par machine et hors dépôt.
    #
    # Ce module étant partagé par les 3 hôtes, déclarer les 3 clés donne un
    # maillage complet : chaque machine peut joindre les deux autres. Chacune
    # s'autorise aussi elle-même — sans effet en pratique.
    #
    # Le commentaire en fin de clé est celui choisi à la génération et ne
    # constitue pas une identification fiable : deux machines portent ici le
    # même « cheon.cv@gmail.com ». C'est le commentaire Nix au-dessus de
    # chaque entrée qui fait foi sur la provenance.
    #
    # Attention : il s'agit de clés SSH publiques, à ne pas confondre avec
    # les clés *age* de clés-publiques.md, qui sont dérivées des clés d'hôte
    # et servent uniquement au chiffrement SOPS.
    openssh.authorizedKeys.keys = [
      # portable — ~/.ssh/id_ed25519.pub
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMF9mEulxwRGXWdbtbuT3BtIZQpCehj815hjpTbDixUc cheon.cv@gmail.com"
      # serveur — ~/.ssh/id_ed25519.pub
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICCUrVLH7ZxQxfnmvP087aBW12XPk9KCxXf9O28z5SgX cheon@serveur"
      # pomme — ~/.ssh/id_ed25519.pub
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIlRRsdzo3u1PseY7UGiPtie4TYBM8cH8nHhA1Y/neGt cheon.cv@gmail.com"
    ];

    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "scanner"
      "lp"
    ];
    packages = with pkgs; [
      firefox
      kitty
      keymapp
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    zip
    unzip
    neovim
    lua-language-server
    git
    gh # github CLI pour faciliter l'authentification avec github.
    claudePkg
    gnupg
    #pinentry
    pinentry-curses
    pass
    openssl
    rclone
    xdg-utils
    pulseaudio ## pour avoir le logiciel pactl qui permet de contrôler le son en ligne de commande.
    dmenu
    dmenu-wayland # pour permettre d'utiliser dmenu et passmenu dans wayland
    xclip
    nitrogen
    wlr-randr
    pkgs-unstable.noctalia-shell
    #pkgs-unstable.quickshell
  ];

  # Installation d'un package pour ricer nixos
  #stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

  # Installation de fonts supplémentaires
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.noto
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    font-awesome
    adwaita-fonts
    nerd-fonts.symbols-only
    #nerd-fonts.adwaita-mono
    # fonts compatible avec Microsoft Arial, Courrier New et Times New Roman
    liberation_ttf
  ];

  programs.localsend = {
    enable = true;
    openFirewall = true; # true par défaut, mais explicite ne fait pas de mal
  };

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
