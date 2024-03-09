# Home.nix 

{ config, pkgs, ... }:

{
  imports =
    [ 
      ../../modules/home-manager/neovim.nix
      ../../modules/home-manager/sway.nix
      ../../modules/home-manager/swayidle.nix
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
    ranger
    tree
    neofetch
    htop
    tmux
    fzf
    fd
    ripgrep
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
  };

  programs.bash = {
      enable = true;
      enableCompletion  = true;
      bashrcExtra = ''
        set -o vi
        bind '"\e[A": history-search-backward'
        bind '"\e[B": history-search-forward'
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
