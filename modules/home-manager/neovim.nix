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
-- Dernier changement: 23 octobre 2024
-- Adaptation du dernier fichier de configuration pour neovim.nix

---------------
-- 1 Settings
---------------
local g = vim.g
local o = vim.o
local opt = vim.opt

g.mapleader = " "
g.maplocalleader = "\\" -- nécessaire pour lazy.nvim
opt.number = true 
opt.relativenumber = true

---- pour utiliser y et p pour le copier coller avec le clipboard
o.clipboard = 'unnamedplus'

---- Configuration du correcteur orthographique
vim.opt.spelllang = 'en_us,fr'
vim.opt.spell = true

---- Configuration pour que VimWiki utilise Markdown
g.vimwiki_list = {{path = '~/Documents/Cerveau', syntax = 'markdown', ext = '.md'}}

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

-- Ajuster l'option tabstop
vim.opt.tabstop = 3
vim.opt.shiftwidth = 3
vim.opt.expandtab = true

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

----Pour afficher rapidement un fichier markdown dans un terminal
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

---- Pour faciliter la navigation avec Ergol
map('n', '+', 'gj')
map('n', '-', 'gk')

---- Pour faciliter la navigation entre les splits
map('n', '<C-J>', '<C-W><C-J>')
map('n', '<C-K>', '<C-W><C-K>')
map('n', '<C-L>', '<C-W><C-L>')
map('n', '<C-H>', '<C-W><C-H>')

-- Pour utiliser ZenMode
map('n', '<leader>z', ':ZenMode<CR>')

----pour utiliser la commande point avec visualautocmd VimEnter * 
map('v', '.', ':norm.<CR>')

--------Pour insérer le nom de fichier complet avec fzf-lua
map ({'i','n','v'}, '<c-x><c-f>', function() require("fzf-lua").complete_path() end) 

--------Pour ouvrir un fichier 
map ('n', '<Leader>sf', function() require('fzf-lua').files({ }) end) -- Permet de chercher un fichier 
map ('n', '<Leader>sg', function() require('fzf-lua').grep({ }) end) -- Permet de chercher un fichier 
map ('n', '<Leader>sl', function() require('fzf-lua').lines({ }) end) -- Permet de chercher un fichier 
map ('n', '<Leader><space>', function() require('fzf-lua').buffers({ }) end) -- Permet de chercher un buffer par son nom
--------Pour chercher un fichier de Vimwiki
map ('n', '<Leader>wf', function() require('fzf-lua').files({ cwd = '~/Documents/Cerveau'}) end) -- Permet de cherche un fichier seulement dans Cerveau
map ('n', '<Leader>wg', function() require('fzf-lua').grep({ cwd = '~/Documents/Cerveau'}) end) -- Permet de cherche un fichier seulement dans Cerveau

--------Pour déplacer d'un lien à l'autre dans un fichier Vimwiki
--map ('n', '<Up>', '<Plug>VimwikiPrevLink')
--map ('n', '<Down>', '<Plug>VimwikiNextLink')

-----Pour insérer la date
map ('n', '<Leader>d', ':r! date \\+\\%A" "\\%d" "\\%B" "\\%Y| sed "s/\\b\\(.\\)/\\u\\1/"<cr>')

-----Pour activer ouvrir mini.files
map ('n', '<Leader>f', function() require('mini.files').open() end) -- Permet de chercher un fichier 

----------------
---- 4 Plugins 
----------------
	
----Activation du plugin lualine
--require 'lualine'.setup()
----Activation du plugin mini.files
require("mini.files").setup({
  mappings = {
    go_in = '<Right>',
    go_out = '<Left>',
  },
})

	'';
      plugins = with pkgs.vimPlugins; [ 
         zen-mode-nvim 
         twilight-nvim  
         vim-pencil 
         vimwiki 
         gruvbox 
         #lualine-nvim 
         fzf-lua 
         nvim-web-devicons 
         mini-files
         #rocks-nvim
         ];
  };
}
