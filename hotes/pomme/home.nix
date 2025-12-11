# Home.nix de pomme

{ config, pkgs, inputs, ...}:

{
  imports =
    [ 
      ../../modules/home-manager/nixvim.nix
    ];

  home.packages = with pkgs; [ 
    #ajouter les packages propres à pomme
    #google-chrome
  ];

  home.stateVersion = "25.11";

  home.username = "cheon";
  home.homeDirectory = "/home/cheon";
  home.sessionPath = ["/usr/local/bin"];

  home.packages = with pkgs; [ 
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
    slides
    tldr

    # Programmation
    lua
    lazygit
    nixfmt-rfc-style # formateur pour les fichiers nix dans nvim

    firefox# À vérifier si l'extension -wayland est toujours pertinente
    kitty

    # Applications de bureau

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
        export PATH="$PATH:/usr/local/bin"
        export MANPAGER="sh -c 'col -bx | bat -l man -p'"
        export MANROFFOPT="-c"
        set -o vi
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
        river = "dbus-run-session river";
        qw = "~/Scripts/qw.sh";
        er = "~/Scripts/er.sh";
      };
  };

  programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
  };

  programs.foot = {
    enable = true;
    settings = {
	    main = {
	      term = "foot";
              font = "Adwaita Mono:size=14";
              #font = "JetBrainsMono Nerd Font Mono:size=14";
              #include = "~/.config/foot/foot-colors.ini";
              #include = "~/.config/foot/gruvbox.foot.ini";
	    };
      csd = {
        preferred = "server";
        hide-when-maximized = "yes";
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
        -- -- Ajout pour le problème de rendering de font après update 14 octobre 2024
        -- config.front_end = "WebGpu" 
        
        config.font = wezterm.font 'JetBrainsMono Nerd Font Mono'
        config.font_size = 14.0
        
        -- config.color_scheme = 'GruvboxDark'
        config.color_scheme_dirs = { '~/.config/wezterm/colors' }
        config.color_scheme = 'matugen'
        
        -- Le max_fps est 60 par défaut, mais le scrolling est plus smooth à 120
        config.max_fps =120 

        config.window_background_opacity = 0.9
        -- config.text_background_opacity = 0.9
        
        -- Activer ou désactiver la tab bar
        config.enable_tab_bar = false
        
        -- Configuration temporaire pour contourner un bug avec wayland et Hyprland
        -- config.enable_wayland = false

        -- configuration des espaces entre le texte et la bordure de la fenêtre
        config.window_padding = {
          left = 2,
          right = 2,
          top = 0,
          bottom = 0,
        }
        -- configuration pour les tiling window manager
        config.adjust_window_size_when_changing_font_size = false

        -- configuration pour permettre des deadkeys d'Ergo-l
        use_dead_keys = true

        return config
      '';
  };

  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  programs.bemenu = {
    enable = true;
    settings = {
      ignorecase = true;
      width-factor = 0.3;
      center = true;
      list = 20;
      fn = "JetBrainsMono 14";
      fb = "#282828";
      ff = "#ebdbb2";
      nb = "#282828";
      nf = "#ebdbb2";
      tb = "#282828";
      hb = "#282828";
      tf = "#fb4934";
      hf = "#fabd2f";
      af = "#ebdbb2";
      ab = "#282828";
      border = 1;
      bdr = "#ebdbb2";
    };
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
