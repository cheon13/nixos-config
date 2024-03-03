# Home.nix 

{ config, pkgs, ... }:

{
  home.username = "cheon";
  home.homeDirectory = "/home/cheon";

  home.packages = with pkgs; [ 
    fortune
    killall
    ranger
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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    extraConfig = 
       ''
        let mapleader="\<Space>"
        set number
        set relativenumber
        
        " pour utiliser y et p pour le copier coller avec le clipboard
        set clipboard+=unnamedplus
        
        " Pour faciliter la navigation entre les splits
        nnoremap <C-J> <C-W><C-J>
        nnoremap <C-K> <C-W><C-K>
        nnoremap <C-L> <C-W><C-L>
        nnoremap <C-H> <C-W><C-H>

        "pour utiliser la commande point avec visualautocmd VimEnter * 
        vnoremap . :norm.<CR>

        "Pour exécuter rapidement un script python dans un terminal
        "autocmd Filetype python nnoremap <buffer> <F7> :w<CR>:vs<CR>:ter python "%"<CR>

        "Pour exécuter rapidement afficher un fichier markdown dans un terminal
        autocmd Filetype markdown nnoremap <buffer> <F7> :w<CR>:!pandoc "%" -o prttmp.pdf --resource-path="%:p:h" && zathura prttmp.pdf && rm prttmp.pdf<CR>
        " Configuration pour que VimWiki utilise Markdown
        let g:vimwiki_list = [{'path': '~/Documents/Cerveau', 'syntax': 'markdown', 'ext': '.md'}]
        " Configuration pour remplacer les liens []() par défaut pour [[]] dans
        " Vimwiki.
        "autocmd VimEnter * let g:vimwiki_syntaxlocal_vars['markdown']['Link1'] = g:vimwiki_syntaxlocal_vars['default']['Link1']
        " Template pour le diary de Vimwiki
        autocmd BufNewFile ~/Documents/Cerveau/diary/[0-9]*.md :silent 0r !echo "\# `date +\%Y-\%m-\%d`"

        " Pour utiliser fzf facilement avec vimwiki
        " --- pour insérer le nom de fichier complet
        imap <c-x><c-f> <plug>(fzf-complete-path)
        " --- pour ouvrir un fichier de vimwiki
        nmap <Leader>wp :Files ~/Documents/Cerveau/<CR>

        " --- Configuration pour que taskwiki utilise Markdown
        " let g:taskwiki_markup_syntax = 'markdown'
       
        "Configuration pour que synchroniser Goyo et Limelight
        autocmd! User GoyoEnter Limelight 0.8
        autocmd! User GoyoLeave Limelight!
        " Configuration pour ajuster le contraste de limelight
        "let g:limelight_default_coefficient = 0.9
        
        " Configuration du correcteur orthographique
        "
        set spell
        set spelllang=en_us,fr
        autocmd FileType markdown setlocal spell

        " Put these in an autocmd group, so that we can delete them easily.
        augroup vimrcEx
          au!
        " For all text files set 'textwidth' to 78 characters.
          autocmd FileType text setlocal textwidth=78
        augroup END

        if has('termguicolors')
          set termguicolors
        endif

        colorscheme gruvbox

        lua require 'lualine'.setup()

        " Setting de vim-pencil
        let g:pencil#wrapModeDefault = 'soft' 

        augroup pencil
          autocmd!
          autocmd FileType markdown,mkd call pencil#init()
          autocmd FileType text         call pencil#init()
        augroup END
      '';
      plugins = with pkgs.vimPlugins; [ goyo-vim limelight-vim vim-pencil vimwiki gruvbox lualine-nvim fzf-vim ];
  };

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

  # Use sway desktop environment with Wayland display server
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    # Sway-specific Configuration
    config = {
      input = { 
        "*" = {
          xkb_layout = "ca";
          # xkb_variant = "";
          # xkb_Options = "caps:swapescape";
          };
      };
      window.titlebar = false;
      modifier = "Mod4";
      keybindings  = let modifier = "Mod4";
      in pkgs.lib.mkOptionDefault {
        "${modifier}+t" = "layout tabbed";
        "${modifier}+w" = "exec firefox";
        "${modifier}+Shift+e" = "exec ~/.config/sway/scripts/power-menu.sh";
        # "${modifier}+Shift+e" = "exec swaymsg exit";
        # "${modifier}+Shift+e" = "exec swaynag -t warning -m 'Voulez-vous vraiment quitter ?' -b 'Yes, exit sway' 'swaymsg exit'";
      };
      terminal = "kitty";
      menu = "wofi --show drun";
      # Status bar(s)
      bars = [{
        command = "waybar";
      }];
      # Display device configuration
      output = {
        eDP-1 = {
          # Set HIDP scale (pixel integer scaling)
          scale = "1";
            };
          };
     startup = [
       # Lancer l'application de fond d'écran au démarrage 
       {command = "swaybg -i /home/cheon/Images/Wallpapers/sway.png";}
     ];
    };
    # End of Sway-specific Configuration
  };
  
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 295;
        command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
      }
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock";
      }
      {
        timeout = 360;
        command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
      }
    ];
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock";
      }
    ];
  };   

  # Configuration de la waybar
  programs.waybar = {
      enable = true;
      settings =  {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          output = [
            # "eDP-1"
            "HDMI-A-1"
          ];
          modules-left = [ "sway/workspaces"  ];
          modules-center = [ "clock" ];
          modules-right = [ "idle_inhibitor" "pulseaudio" "network" "tray" ];
          "sway/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
          };
          "clock" = {
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              format-alt = "{:%Y-%m-%d}";
          };
          "idle_inhibitor" = {
              format = "{icon}";
              format-icons = {
                  activated = "";
                  deactivated = "";
              };
          };
          "pulseaudio" = {
              format = "{volume}% {icon} {format_source}";
              format-bluetooth = "{volume}% {icon} {format_source}";
              format-bluetooth-muted = " {icon} {format_source}";
              format-muted =  " {format_source}";
              format-source =  "{volume}% ";
              format-source-muted =  "";
              format-icons =  {
                  headphone =  "";
                  hands-free =  "";
                  headset =  "";
                  phone =  "";
                  portable =  "";
                  car =  "";
                  default = "";
              };
              on-click = "pavucontrol";
          };
          "network" = {
              format-wifi = "{essid} ({signalStrength}%) ";
              format-ethernet = "{ipaddr}/{cidr} ";
              tooltip-format = "{ifname} via {gwaddr} ";
              format-linked = "{ifname} (No IP) ";
              format-disconnected = "Disconnected ⚠";
              format-alt = "{ifname}: {ipaddr}/{cidr}";
          };
        };  
      };
      style = ''
        * {
            font-family: JetBrainsMono;
            font-size: 15px;
            border: none;
            border-radius: 0;
            min-height: 0;
            margin: 1px;
            padding: 0;
        }

        window#waybar {
            background: transparent;
            background-color: rgba(50, 50, 50, 0.5);
            color: #ebdbb2;
        }

        button {
            box-shadow: inset 0 -3px transparent;
            border: none;
            border-radius: 0;
        }
        
        button:hover {
            background: inherit;
            box-shadow: inset 0 -3px #ebdbb2;
        }
        
        #workspaces button {
            padding: 0 5px;
            background-color: transparent;
            color: #ebdbb2;
        }
        
        #workspaces button:hover {
            background: rgba(0, 0, 0, 0.2);
        }
        
        #workspaces button.focused {
            border:  1px solid;
            border-color: #ebdbb2;
        }
        
        #workspaces button.urgent {
            background-color: #eb4d4b;
        }
        #clock,
        #network,
        #pulseaudio,
        #wireplumber,
        #custom-media,
        #tray,
        #idle_inhibitor {
            padding: 0 10px;
            color: #ebdbb2;
        }
        
        #window,
        #workspaces {
            padding:0 1px;
            margin: 1px 0px;
        }
        '';
  };

  # Configuration de la wofi
  programs.wofi = {
      enable = true;
      settings =  { };
      style = ''
        /*
        Gruvbox Color Scheme
        */
        
        #window {
        margin: 0px;
        border: 1px solid #928374;
        background-color: #282828;
        }
        
        #input {
        margin: 5px;
        border: none;
        color: #ebdbb2;
        background-color: #1d2021;
        }
        
        #inner-box {
        margin: 5px;
        border: none;
        background-color: #282828;
        }
        
        #outer-box {
        margin: 5px;
        border: none;
        background-color: #282828;
        }
        
        #scroll {
        margin: 0px;
        border: none;
        }
        
        #text {
        margin: 5px;
        border: none;
        color: #ebdbb2;
        }
        
        #entry:selected {
        background-color: #1d2021;
        }
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
