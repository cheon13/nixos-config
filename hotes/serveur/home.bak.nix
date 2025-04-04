# Home.nix 

{ config, pkgs, inputs, ...}:

{
  imports =
    [ 
      #../../modules/home-manager/neovim.nix
      ../../modules/home-manager/nixvim.nix
      ../../modules/home-manager/sway.nix
      #../../modules/home-manager/swayidle.nix  # finalement swayidle est intégré directement à Sway et Hyprland
      ../../modules/home-manager/waybar
      ../../modules/home-manager/swaylock.nix
      ../../modules/home-manager/wofi.nix
      ../../modules/home-manager/hyprland.nix
      ../../modules/home-manager/hyprpaper.nix
      ../../modules/home-manager/river.nix
    ];

  home.username = "cheon";
  home.homeDirectory = "/home/cheon";
  home.sessionPath = ["/usr/local/bin"];

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
    texlive.combined.scheme-small
    slides
    lynx	
    tldr

    # Programmation
    python3
    lua
    lazygit

    # Pour la musique
    pavucontrol
    termusic
    cava
    yt-dlp # pour télécharger la musique de youtube
    clementine # Pour jouer et indexer la musique

          # All of the below is for sway and Hyprland
    swaylock
    swayidle
    swaybg
    wl-clipboard
    mako
    libnotify
    wofi
    tofi
    waybar
    grim
    slurp
    imv
    networkmanagerapplet
    hyprcursor
    capitaine-cursors-themed
    firefox-wayland
    qutebrowser
    alacritty
    kitty
    wezterm
    libreoffice
    nixfmt-rfc-style # formateur pour les fichiers nix dans nvim
  ];

  programs.git = {
      enable = true;
      userName  = "cheon13";
      userEmail = "cheon.cv@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
  };

  programs.bash = {
      enable = true;
      enableCompletion  = true;
      bashrcExtra = ''
        export PATH="$PATH:/usr/local/bin"
        export MANPAGER="sh -c 'col -bx | bat -l man -p'"
        export MANROFFOPT="-c"
        set -o vi
        bind '"\e[A": history-search-backward'
        bind '"\e[B": history-search-forward'
       	eval "$(fzf --bash)"
       	eval "$(zoxide init bash)"
       	eval "$(starship init bash)"
      '';
      shellAliases = {
        ls = "eza --icons --group-directories-first";
        lt = "eza --icons -T";
        la = "eza -a --icons --group-directories-first";
        ll = "eza -l --icons --group-directories-first";  
        lla = "eza -la --icons --group-directories-first";
	      cd = "z";
      };
  };

  home.file.".xinitrc".text = ''
    # Fichier de configuration pour startx
    #
    # Pour le fond d'écran
    nitrogen --restore &
    # Pour donner le status dans la barre de DWM
    slstatus &
    # La ligne suivant n'est pas nécessaire parce que intercept-tools s'en occupe pour la Console, Wayland et X11
    # setxkbmap -option caps:swapescape
    exec dwm  # cette ligne est nécessaire si les fichiers est .xinitrc, mais pas pour .xprofile
  '';

  programs.kitty = {
      enable = true;
      font.name  = "JetBrainsMono Nerd Font Mono";
      font.size = 14.0;
      settings = {
        background_opacity = 0.9;
        enable_audio_bell = "no";
        editor = "/etc/profiles/per-user/cheon/bin/nvim";
        tab_bar_edge = "top";
        tab_bar_style = "powerline";
      };
      keybindings = {
        "ctrl+shift+¨" = "next_window";
        "ctrl+shift+^" = "previous_window";
        "ctrl+shift+enter" = "new_window_with_cwd";
      };
      themeFile = "gruvbox-dark";
  };

  programs.foot = {
    enable = true;
    settings = {
	    main = {
	      term = "foot";
              font = "JetBrainsMono Nerd Font Mono:size=14";
	    };
	    colors = { 
	      alpha = 0.9;
	      # configuration gruvbox dark
        background = "282828";
        foreground = "ebdbb2";
        regular0 = "282828";
        regular1 = "cc241d";
        regular2 = "98971a";
        regular3 = "d79921";
        regular4 = "458588";
        regular5 = "b16286";
        regular6 = "689d6a";
        regular7 = "a89984";
        bright0 = "928374";
        bright1 = "fb4934";
        bright2 = "b8bb26";
        bright3 = "fabd2f";
        bright4 = "83a598";
        bright5 = "d3869b";
        bright6 = "8ec07c";
        bright7 = "ebdbb2";
	    };
    };
  };

  programs.wezterm = {
      enable = true;
      extraConfig = ''
        local config = wezterm.config_builder()
        -- Ajout pour le problème de rendering de font après update 14 octobre 2024
        config.front_end = "WebGpu" 
        
        config.font = wezterm.font 'JetBrainsMono Nerd Font Mono'
        config.font_size = 14.0
        
        config.color_scheme = 'GruvboxDark'
        
        config.window_background_opacity = 0.9
        config.text_background_opacity = 0.9
        
        -- Activer ou désactiver la tab bar
        config.enable_tab_bar = false
        
        -- Configuration temporaire pour contourner un bug avec wayland et Hyprland
        config.enable_wayland = false
        
        return config
      '';
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
