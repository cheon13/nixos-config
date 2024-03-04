{ pkgs, ... }:

{
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

}
