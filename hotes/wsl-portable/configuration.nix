# Edit this configuration file to define what should be installed on your system. Help is 
# available in the configuration.nix(5) man page, on https://search.nixos.org/options and in 
# the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository: 
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{ imports = [
    <home-manager/nixos>
    # include NixOS-WSL modules
    <nixos-wsl/modules> ];

  wsl.enable = true; wsl.defaultUser = "cheon"; wsl.wslConf.network.generateHosts = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

# Setting environment Variables for all users
  environment.sessionVariables = {
    EDITOR = "nvim";
  };

# List packages installede in system profile
  environment.systemPackages = [
    pkgs.neovim
  ];  

  networking.hostName = "wsl-portable"; # Define your hostname.
  #networking.hostName = "DESKTOP-UEM9CA3"; # Define your hostname.

  # Ajout manuel au fichiers /etc/hosts
  networking.extraHosts = ''
    10.0.0.201 portable
    10.0.0.200 serveur
    10.0.0.202 phone
    10.0.0.203 tablette
  '';

  environment.interactiveShellInit = ''
    alias phone='ssh u0_a450@phone -p8022'
    alias portable='ssh portable'
    alias serveur='ssh serveur'
  '';

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_CA.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cheon = {
    isNormalUser = true;
    description = "Christian Héon";
    # extraGroups = [ "networkmanager" "wheel" "audio"];
    packages = with pkgs; [
     # firefox
     neofetch
     zathura
     htop
    ];
  };

  # Begin home-manager directives
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
 
  home-manager.users.cheon = { pkgs, ... }: {
    # Everything inside here is managed by Home Manager!
    home.packages = with pkgs; [ 
      fortune
      killall
      ranger
      tmux
      fzf
      ripgrep
      pandoc
      texlive.combined.scheme-small
      slides
      lynx	
      kitty
      taskwarrior
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
          let g:vimwiki_list = [{'path': '/mnt/c/Users/Utilisateur/OneDrive/Documents/Cerveau/', 'syntax': 'markdown', 'ext': '.md'}]
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
        '';
	plugins = with pkgs.vimPlugins; [ goyo-vim vimwiki gruvbox limelight-vim lualine-nvim fzf-vim ];
    };

    programs.git = {
        enable = true;
        userName  = "Christian Héon";
        userEmail = "cheon.cv@gmail.com";
    };

    programs.home-manager = {
      enable = true;
    };
    home.stateVersion = "23.05";
  };

  # Installation de fonts supplémentaires
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    jetbrains-mono
    nerdfonts
    powerline-fonts # pour utiliser airline
  ];
    
  # This value determines the NixOS release from which the default settings for stateful data, 
  # like file locations and database versions on your system were taken. It's perfectly fine 
  # and recommended to leave this value at the release version of the first install of this 
  # system. Before changing this value read the documentation for this option (e.g. man 
  # configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
