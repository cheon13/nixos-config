{ pkgs, modulesPath, ... }: {
# pour construire l'image : nix build .#nixosConfigurations.customIso.config.system.build.isoImage
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 


  networking.hostName = "customIso"; # Define your hostname.
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
    killall
    ranger
    tree
    neofetch
    htop
  ];

}
