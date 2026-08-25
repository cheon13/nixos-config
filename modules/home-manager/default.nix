# Module de home-manager

{ pkgs, pkgs-unstable, ... }:

{
  imports =
    [ 
      #./neovim.nix
      ./nixvim.nix
      ./dwl.nix
      ./swaylock.nix
      ./emacs.nix
    ];
  home.username = "cheon";
  home.homeDirectory = "/home/cheon";
  home.sessionPath = ["/usr/local/bin" "/home/cheon/.local/bin"];

  home.packages = with pkgs; [ 
    fortune
    killall
    bat
    tree
    fastfetch
    btop
    tmux
    fzf
    fd
    eza
    ripgrep
    trashy
    starship
    zellij
    glow
    zoxide
    yazi
    zathura
    pandoc
    #texlive.combined.scheme-small
    (texlive.combine {
      inherit (texlive) scheme-medium wrapfig capt-of listings beamer;
    })
    slides
    lynx	
    tldr

    # Programmation
    python3
    lua
    lazygit
    nixfmt # formateur pour les fichiers nix dans nvim

    # Pour la musique
    pavucontrol
    termusic
    termsonic
    cliamp
    cava
    yt-dlp # pour télécharger la musique de youtube
    clementine # Pour jouer et indexer la musique

    # Outils wayland généraux (la pile propre à dwl est dans modules/nixos/dwl.nix)
    swaylock
    swayidle
    mako
    libnotify
    imv
    brightnessctl
    matugen # générateur de couleur pour le ricing d'applications automatique
    pywalfox-native # pour appliquer les couleur de matugen (équivalent de pywal) à firefox

    networkmanagerapplet
    #hyprcursor
    #capitaine-cursors-themed
    firefox# À vérifier si l'extension -wayland est toujours pertinente
    qutebrowser
    geary # email client
    alacritty
    kitty

    # Applications de bureau
    iotas # application pour prendre des notes markdown et qui se synchronise avec nextcloud notes
    libreoffice
    hunspell
    hunspellDicts.fr-any
    hunspellDicts.en_US
    jdk # nécessaire pour installer les extensions libreoffice
    
    butterfly # Logiciel de dessin et tableau blanc
    gnumeric
    abiword
    marp-cli # Pour faire des présentation à partir de markdown

    typst
    typstPackages.hydra

    gnome-solanum # pomodoro pour gnome
  ];

  programs.git = {
      enable = true;
      settings = {
        user.name  = "cheon13";
        user.email = "cheon.cv@gmail.com";
        init.defaultBranch = "main";
      };
  };

  programs.bash = {
      enable = true;
      enableCompletion  = true;
      historySize = 100000;
      bashrcExtra = ''
        export PATH="$PATH:/usr/local/bin:/home/cheon/.local/bin"
        export MANPAGER="sh -c 'col -bx | bat -l man -p'"
        export MANROFFOPT="-c"
        bind '"\e[A": history-search-backward'
        bind '"\e[B": history-search-forward'
       	eval "$(fzf --bash)"
       	# eval "$(zoxide init bash)"
       	eval "$(starship init bash)"
      '';
      shellAliases = {
        ls = "eza --icons --group-directories-first";
        lt = "eza --icons -T";
        la = "eza -a --icons --group-directories-first";
        ll = "eza -lg --icons --group-directories-first";  
        lla = "eza -lga --icons --group-directories-first";
	      cd = "z";
        df = "df -h -x tmpfs";
        nk = "NVIM_APPNAME='nvim-kickstart' nvim";
        nt = "NVIM_APPNAME='nvim-test' nvim";
        rm = "rm -i --preserve-root";
        cp = "cp -i";
        mkdir = "mkdir -p";
        ping = "ping -c 5";
      };
  };

  programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
  };

  programs.kitty = {
      enable = true;
      font.name  = "JetBrainsMono Nerd Font Mono";
      font.size = 14.0;
      settings = {
        background_opacity = 0.9;
        enable_audio_bell = "no";
        editor = "emacsclient -t -a emacs";  # aligné sur EDITOR (cf. modules/nixos/default.nix)
        tab_bar_edge = "top";
        tab_bar_style = "powerline";
        hide_window_decorations = "yes";
      };
      keybindings = {
        "ctrl+shift+¨" = "next_window";
        "ctrl+shift+^" = "previous_window";
        "ctrl+shift+enter" = "new_window_with_cwd";
      };
      #themeFile = "gruvbox-dark";
      extraConfig = "include colors.conf";
  };

  programs.foot = {
    enable = true;
    settings = {
	    main = {
	      term = "foot";
        font = "Adwaita Mono:size=14";
        #font = "JetBrainsMono Nerd Font Mono:size=14";
        include = "~/.config/foot/foot-colors.ini";
        #include = "~/.config/foot/gruvbox.foot.ini";
        resize-by-cells = "no"; # pour régler problème dans paperwm
	    };
      csd = {
        preferred = "none";
        #preferred = "server";
        #hide-when-maximized = "yes";
      };
	   # colors = { 
	   #   alpha = 0.9;
	   #   # configuration gruvbox dark
     #   background = "282828";
     #   foreground = "ebdbb2";
     #   regular0 = "282828";
     #   regular1 = "cc241d";
     #   regular2 = "98971a";
     #   regular3 = "d79921";
     #   regular4 = "458588";
     #   regular5 = "b16286";
     #   regular6 = "689d6a";
     #   regular7 = "a89984";
     #   bright0 = "928374";
     #   bright1 = "fb4934";
     #   bright2 = "b8bb26";
     #   bright3 = "fabd2f";
     #   bright4 = "83a598";
     #   bright5 = "d3869b";
     #   bright6 = "8ec07c";
     #   bright7 = "ebdbb2";
	   # };
    };
  };


  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  # Associations MIME.
  #
  # ~/.config/mimeapps.list est un lien vers le nix store, donc en LECTURE SEULE :
  # `xdg-mime default …` en ligne de commande échouera. Tout se déclare ici.
  #
  # Sans entrée explicite, xdg retombe sur le mimeinfo.cache et c'est l'ordre de
  # XDG_DATA_DIRS qui tranche — où Flatpak passe avant les profils Nix. C'est
  # ainsi qu'Apostrophe (flatpak) récupérait text/plain. D'où les entrées texte
  # ci-dessous, explicites.
  xdg.mimeApps = {
    enable = true;
    defaultApplications = let
      # Daemon Emacs : `--reuse-frame` quand un fichier est passé en argument,
      # `--alternate-editor=` démarre le daemon s'il ne tourne pas encore.
      emacs = "emacsclient.desktop";
    in {
      "text/html"                = "firefox.desktop";
      "x-scheme-handler/http"   = "firefox.desktop";
      "x-scheme-handler/https"  = "firefox.desktop";
      "x-scheme-handler/about"  = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      "image/jpeg"               = "imv.desktop";
      "image/png"                = "imv.desktop";
      "image/gif"                = "imv.desktop";
      "image/webp"               = "imv.desktop";
      "image/svg+xml"            = "imv.desktop";
      "image/tiff"               = "imv.desktop";
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "writer.desktop";
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"       = "calc.desktop";
      "application/msword"       = "writer.desktop";
      "application/vnd.ms-excel" = "calc.desktop";
      "application/pdf"          = "org.pwmt.zathura.desktop";

      # Texte et markdown
      "text/plain"               = emacs;
      "text/markdown"            = emacs;
      "text/x-markdown"          = emacs;
      "text/x-log"               = emacs;

      # Code
      "text/x-python"            = emacs;
      "text/x-lua"               = emacs;
      "text/x-csrc"              = emacs;
      "text/x-chdr"              = emacs;
      "text/x-c++src"            = emacs;
      "text/x-c++hdr"            = emacs;
      "text/x-java"              = emacs;
      "text/x-makefile"          = emacs;
      "text/x-tex"               = emacs;
      "text/x-shellscript"       = emacs;
      "application/x-shellscript" = emacs;

      # Configuration / données
      "text/x-nix"               = emacs;
      "application/json"         = emacs;
      "application/x-yaml"       = emacs;
      "application/yaml"         = emacs;  # type enregistré depuis RFC 9512
      "text/x-yaml"              = emacs;
      "application/toml"         = emacs;
      "text/x-ini"               = emacs;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
