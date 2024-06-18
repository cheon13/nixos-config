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
    taskwarrior
    python3
          # All of the below is for sway
    swaylock
    swayidle
    wl-clipboard
    mako
    wofi
    tofi
    waybar
    swaybg
    grim
    imv
    firefox-wayland
    kitty
    wezterm
    libreoffice
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
	eval "$(zoxide init bash)"
	eval "$(starship init bash)"
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
