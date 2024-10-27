# Home.nix 

{ config, pkgs, inputs,... }:

{
  imports =
    [ 
      ../../modules/home-manager/neovim.nix
      ../../modules/home-manager/sway.nix
      #../../modules/home-manager/swayidle.nix  # finalement swayidle est intégré directement à Sway et Hyprland
      ../../modules/home-manager/waybar.nix
      ../../modules/home-manager/wofi.nix
      ../../modules/home-manager/hyprland.nix
      ../../modules/home-manager/hyprpaper.nix
    ];

  home.username = "cheon";
  home.homeDirectory = "/home/cheon";

  home.packages = with pkgs; [ 
    fortune
    killall
    bat
    ranger
    tree
    neofetch
    fastfetch
    htop
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
    # taskwarrior # à changer pour taskwarrior3
    python3
    lua
          # All of the below is for sway and Hyprland
    swaylock
    swayidle
    wl-clipboard
    mako
    libnotify
    wofi
    tofi
    waybar
    swaybg
    grim
    imv
    hyprcursor
    capitaine-cursors-themed
    firefox-wayland
    qutebrowser
    kitty
    wezterm
    libreoffice
    jdk # nécessaire pour installer les extensions libreoffice
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
        nk = "NVIM_APPNAME='nvim-kickstart' nvim";
      };
  };

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
      extraCongif = ''
        return {}
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
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
