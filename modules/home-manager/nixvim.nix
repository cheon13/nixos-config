# Configuration de neovim avec nixvim
#Samedi 04 janvier 2025

{self, pkgs, ...}: {
  # Import all your configuration modules here
  imports = 
    [
      inputs.nixvim.nixosModule.nixvim
      ./bufferline.nix 
    ];
    
  globals.mapleader = " ";

  extraConfigLua = "vim.g.vimwiki_list = {{path = '~/Documents/Cerveau', syntax = 'markdown', ext = '.md'}}";

  opts = {
    number = true;         # Show line numbers
    relativenumber = true; # Show relative line numbers

    tabstop = 2;
    shiftwidth = 2;        # Tab width should be 2
    expandtab = true;

    spelllang = "en_us,fr";
    spell = true;

    hlsearch = false;
    undofile = true;
    ignorecase = true;
    smartcase = true;
  };
  
  #clipboard.register = "unnamedplus";

  #colorschemes.gruvbox.enable = true;

  #autoCmd = [
  #  { 
  #    command = "nnoremap <buffer> <F7> :w<CR>:!pandoc '%' -o prttmp.pdf --resource-path='%:p:h' && zathura prttmp.pdf && rm prttmp.pdf<CR>";
  #    event = [
  #      "Filetype"
  #  ];
  #    pattern = "markdown"; 
  #  }

  #  { 
  #    command = ''nnoremap <buffer> <F7> :w<CR>:vs<CR>:ter python "%"<CR>'';
  #    event = [
  #      "BufEnter"
  #      "BufWinEnter"
  #  ];
  #    pattern = "*.py"; 
  #  }
  #];

  keymaps = [
    #navigation entre les splits
    {
      mode = "n";
      key = "<C-J>";
      action = "<C-W><C-J>";
    }
    {
      mode = "n";
      key = "<C-K>";
      action = "<C-W><C-K>";
    }
    {
      mode = "n";
      key = "<C-L>";
      action = "<C-W><C-L>";
    }
    {
      mode = "n";
      key = "<C-H>";
      action = "<C-W><C-H>";
    }
    # Pour utiliser ZenMode
    {
      mode = "n";
      key = "<leader>z";
      action = ":ZenMode<CR>";
    }
    # Pour utiliser la command point avec visualautocmd VimEnter *
    {
      mode = "v";
      key = ".";
      action = ":norm.<CR>";
    }
    # Pour insérer le nom de fichier complet avec fzf-lua
    {
      mode = ["i" "n" "v"];
      key = "<c-x><c-f>";
      action = '':lua require("fzf-lua").complete_path()<CR>'';
    }
    # Pour ouvrir un fichier en cherchant son nom
    {
      mode = "n";
      key = "<Leader>sf";
      action = '':lua require("fzf-lua").files()<CR>'';
    }
    # Pour ouvrir un fichier en cherchant son contenu
    {
      mode = "n";
      key = "<Leader>sg";
      action = '':lua require("fzf-lua").grep()<CR>'';
    }
    # Pour ouvrir un buffer en cherchant une ligne, va à la ligne
    {
      mode = "n";
      key = "<Leader>sl";
      action = '':lua require("fzf-lua").lines()<CR>'';
    }
    # Pour ouvrir un buffer en cherchant son nom
    {
      mode = "n";
      key = "<Leader><space>";
      action = '':lua require("fzf-lua").buffers()<CR>'';
    }
    # Pour ouvrir un fichier Vimwiki en cherchant son nom
    {
      mode = "n";
      key = "<Leader>wf";
      action = '':lua require("fzf-lua").files({ cwd = '~/Documents/Cerveau'})<CR>'';
    }
    # Pour ouvrir un fichier en cherchant son contenu
    {
      mode = "n";
      key = "<Leader>wg";
      action = '':lua require("fzf-lua").grep({ cwd = '~/Documents/Cerveau'})<CR>'';
    }
    # Pour insérer la date
    {
      mode = "n";
      key = "<Leader>d";
      #action = '':r! date +\%A" "\%d" "\%B" "\%Y<CR>'';
      action = '':r! date +\%A" "\%d" "\%B" "\%Y | sed "s/\b\(.\)/\u\1/"<CR>'';
    }
    # Pour ouvrir mini.files
    {
      mode = "n";
      key = "<Leader>f";
      action = ''<cmd>lua require("mini.files").open()<CR>'';
    }
  ];

  plugins.lsp = {
    enable = true;
    servers = {
        lua_ls = {
          enable = true;
          settings = {
            telemetry.enable = false;
            diagnostics.globals = ["vim"];
          };
        };
    };
};

  plugins.cmp = {
    autoEnableSources = true;
    settings = {
      sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
      mapping = {
        "<C-d>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-e>" = "cmp.mapping.close()";
        "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
      };
    };
  };

  plugins.lualine = {
    enable = true;
  };

  plugins.zen-mode = {
    enable = true;
  };

  plugins.twilight = {
    enable = true;
  };
  
  plugins.fzf-lua = {
    enable = true;
  };


  extraPlugins = with pkgs.vimPlugins; [
    vimwiki
    { 
      plugin = mini-files;
      config = ''lua require "mini.files".setup()'';
    }
  ];

#  plugins.render-markdown = {
#    enable = true;
#  };
}
