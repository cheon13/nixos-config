{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    extraLuaConfig = 
    	''
	  -- Mon fichier de configuration inspiré de celui dépôt Github numToStr/dotfiles 
          -- Dernier changement: 30 juin 2023
          
          ---------------
          -- 1 Settings
          ---------------
          local g = vim.g
          local o = vim.o
          local opt = vim.opt
          
          g.mapleader = " "
          g.mapleader = " "
          opt.number = true 
          opt.relativenumber = true
          
          ---- pour utiliser y et p pour le copier coller avec le clipboard
          o.clipboard = 'unnamedplus'
          
          ---- Configuration du correcteur orthographique
          vim.opt.spelllang = 'en_us,fr'
          vim.opt.spell = true
          
          ---- Configuration pour que VimWiki utilise Markdown
          g.vimwiki_list = {{path = '~/Documents/Cerveau', syntax = 'markdown', ext = '.md'}}
          
          ---- Configuration pour ajuster le contraste de limelight
          g.limelight_conceal_ctermfg = 'DarkGray'
          
          ---- Configuration pour le colorscheme
          vim.o.background = "dark" -- or "dark" or "light" for light mode
          vim.cmd([[colorscheme gruvbox]])
          
          -- Set highlight on search
          vim.o.hlsearch = false
          
          -- Save undo history
          vim.o.undofile = true
          
          -- Case-insensitive searching UNLESS \C or capital in search
          vim.o.ignorecase = true
          vim.o.smartcase = true
          
          --------------
          -- 3 Autocmd
          --------------
          local augroup = vim.api.nvim_create_augroup   -- Create/get autocommand group
          local autocmd = vim.api.nvim_create_autocmd   -- Create autocommand
          
          --Pour exécuter rapidement un script python dans un terminal
          autocmd('Filetype', { 
            pattern = 'python', 
            command = 'nnoremap <buffer> <F7> :w<CR>:vs<CR>:ter python "%"<CR>'
            })
          
          ----Pour exécuter rapidement afficher un fichier markdown dans un terminal
          autocmd('Filetype', { 
            pattern = 'markdown', 
            command = 'nnoremap <buffer> <F7> :w<CR>:!pandoc "%" -o prttmp.pdf --resource-path="%:p:h" && zathura prttmp.pdf && rm prttmp.pdf<CR>'
            })
          
          ---- Template pour le diary de Vimwiki
          autocmd('BufNewFile', {
            pattern = '/home/cheon/Documents/Cerveau/diary/[0-9]*.md',
            command = [[silent 0r !echo "\# `date +\%Y-\%m-\%d`"]] 
            -- command = 'silent 0r !echo # `date +%Y-%m-%d`' 
            })
          
          ------------------
          -- 3 Keybindings
          ------------------
          local function map(m, k, v)
              vim.keymap.set(m, k, v, { silent = true })
          end
          
          ---- Pour faciliter la navigation entre les splits
          map('n', '<C-J>', '<C-W><C-J>')
          map('n', '<C-K>', '<C-W><C-K>')
          map('n', '<C-L>', '<C-W><C-L>')
          map('n', '<C-H>', '<C-W><C-H>')
          map('n', '<leader>z', ':TZAtaraxis<CR>')
          
          ----pour utiliser la commande point avec visualautocmd VimEnter * 
          map('v', '.', ':norm.<CR>')
          ----pour utiliser fzf avec vimwiki
          --------Pour insérer le nom de fichier complet
          map ('i', '<c-x><c-f>', '<plug>(fzf-complete-path)')
          --------Pour ouvrir un fichier de Vimwiki
          map ('n', '<Leader>wp', ':Files ~/Documents/Cerveau/<CR>')
          ----Activation du plugin lualine
	  require 'lualine'.setup()
	'';
    #extraConfig = 
    #   ''
    #    let mapleader="\<Space>"
    #    set number
    #    set relativenumber
    #    
    #    " pour utiliser y et p pour le copier coller avec le clipboard
    #    set clipboard+=unnamedplus
    #    
    #    " Pour faciliter la navigation entre les splits
    #    nnoremap <C-J> <C-W><C-J>
    #    nnoremap <C-K> <C-W><C-K>
    #    nnoremap <C-L> <C-W><C-L>
    #    nnoremap <C-H> <C-W><C-H>

    #    "pour utiliser la commande point avec visualautocmd VimEnter * 
    #    vnoremap . :norm.<CR>

    #    "Pour exécuter rapidement un script python dans un terminal
    #    "autocmd Filetype python nnoremap <buffer> <F7> :w<CR>:vs<CR>:ter python "%"<CR>

    #    "Pour exécuter rapidement afficher un fichier markdown dans un terminal
    #    autocmd Filetype markdown nnoremap <buffer> <F7> :w<CR>:!pandoc "%" -o prttmp.pdf --resource-path="%:p:h" && zathura prttmp.pdf && rm prttmp.pdf<CR>
    #    " Configuration pour que VimWiki utilise Markdown
    #    let g:vimwiki_list = [{'path': '~/Documents/Cerveau', 'syntax': 'markdown', 'ext': '.md'}]
    #    " Configuration pour remplacer les liens []() par défaut pour [[]] dans
    #    " Vimwiki.
    #    "autocmd VimEnter * let g:vimwiki_syntaxlocal_vars['markdown']['Link1'] = g:vimwiki_syntaxlocal_vars['default']['Link1']
    #    " Template pour le diary de Vimwiki
    #    autocmd BufNewFile ~/Documents/Cerveau/diary/[0-9]*.md :silent 0r !echo "\# `date +\%Y-\%m-\%d`"

    #    " Pour utiliser fzf facilement avec vimwiki
    #    " --- pour insérer le nom de fichier complet
    #    imap <c-x><c-f> <plug>(fzf-complete-path)
    #    " --- pour ouvrir un fichier de vimwiki
    #    nmap <Leader>wp :Files ~/Documents/Cerveau/<CR>

    #    " --- Configuration pour que taskwiki utilise Markdown
    #    " let g:taskwiki_markup_syntax = 'markdown'
    #   
    #    "Configuration pour que synchroniser Goyo et Limelight
    #    autocmd! User GoyoEnter Limelight 0.8
    #    autocmd! User GoyoLeave Limelight!
    #    " Configuration pour ajuster le contraste de limelight
    #    "let g:limelight_default_coefficient = 0.9
    #    
    #    " Configuration du correcteur orthographique
    #    "
    #    set spell
    #    set spelllang=en_us,fr
    #    autocmd FileType markdown setlocal spell

    #    " Put these in an autocmd group, so that we can delete them easily.
    #    augroup vimrcEx
    #      au!
    #    " For all text files set 'textwidth' to 78 characters.
    #      autocmd FileType text setlocal textwidth=78
    #    augroup END

    #    if has('termguicolors')
    #      set termguicolors
    #    endif

    #    colorscheme gruvbox

    #    lua require 'lualine'.setup()

    #    " Setting de vim-pencil
    #    let g:pencil#wrapModeDefault = 'soft' 

    #    augroup pencil
    #      autocmd!
    #      autocmd FileType markdown,mkd call pencil#init()
    #      autocmd FileType text         call pencil#init()
    #    augroup END
    #  '';
      plugins = with pkgs.vimPlugins; [ true-zen-nvim twilight-nvim  vim-pencil vimwiki gruvbox lualine-nvim fzf-vim ];
  };
}
