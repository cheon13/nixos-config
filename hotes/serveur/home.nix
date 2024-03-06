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
    ];

  wayland.windowManager.hyprland.enable = true;

  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    bind =
      [
        "$mod, Return, exec, kitty"
        "$mod, W, exec, firefox"
	"$mod SHIFT, Q, killactive,"
	"$mod SHIFT, E, exit,"
	"$mod, V, togglefloating,"
	"$mod, D, exec, wofi --show drun"

        # Move focus with mainMod + arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        
        # Move focus with mainMod + hlkj
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        
        # Move window
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"
        
        # Switch workspaces with mainMod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        
        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        #", Print, exec, grimblast copy area"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );
  };

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
