# Configuration de neovim avec nixvim
# Samedi 04 janvier 2025

{ self, pkgs, ... }:
{
  # Import all your configuration modules here
  imports = [
    ./bufferline.nix
  ];
  programs.nixvim = {
    enable = true;
    globals.mapleader = " ";

    defaultEditor = true;
    vimAlias = true;
    viAlias = true;

    extraConfigLua = ''
      vim.g.vimwiki_list = {{path = '~/Documents/Cerveau', syntax = 'markdown', ext = '.md'}}

      vim.cmd "highlight Normal guibg=none"

      require("mini.files").setup({
        mappings = {
          go_in = '<Right>',
          go_out = '<Left>',
        },
      })
    '';

    opts = {
      number = true; # Show line numbers
      relativenumber = true; # Show relative line numbers

      tabstop = 2;
      shiftwidth = 2; # Tab width should be 2
      expandtab = true;

      spelllang = "en_us,fr";
      spell = true;

      hlsearch = false;
      undofile = true;
      ignorecase = true;
      smartcase = true;
    };

    clipboard.register = "unnamedplus";

    colorschemes.gruvbox.enable = true;

    autoCmd = [
      {
        command = "nnoremap <buffer> <F7> :w<CR>:!pandoc '%' -o prttmp.pdf --resource-path='%:p:h' && zathura prttmp.pdf && rm prttmp.pdf<CR>";
        event = [
          "Filetype"
        ];
        pattern = "markdown";
      }

      {
        command = ''nnoremap <buffer> <F7> :w<CR>:vs<CR>:ter python "%"<CR>'';
        event = [
          "BufEnter"
          "BufWinEnter"
        ];
        pattern = "*.py";
      }
    ];

    keymaps = [
      # faciliter navigation j et k avec ergol
      {
        mode = "n";
        key = "+";
        action = "gj";
      }
      {
        mode = "n";
        key = "-";
        action = "gk";
      }
      # Pour séparer TAB de Control-I
      {
        mode = "n";
        key = "<C-I>";
        action = "<C-I>";
      }
      #navigation entre les splits
      {
        mode = "n";
        key = "<C-Down>";
        action = "<C-W><C-J>";
      }
      {
        mode = "n";
        key = "<C-Up>";
        action = "<C-W><C-K>";
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = "<C-W><C-L>";
      }
      {
        mode = "n";
        key = "<C-Left>";
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
        mode = [
          "i"
          "n"
          "v"
        ];
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
      # Raccourci pour une sortie du mode insert du terminal plus convivial
      {
        mode = "t";
        key = "<Escape>";
        action = ''<C-\><C-n>'';
      }
    ];

    plugins.lsp = {
      enable = true;
      servers = {
        lua_ls = {
          enable = true;
          settings = {
            telemetry.enable = false;
            diagnostics.globals = [ "vim" ];
          };
        };
        nixd = {
          enable = true;
          settings = {
            formatting.command = [ "nixfmt" ];
            nixpkgs.expr = "import <nixpkgs> {}";
          };
        };
      };
    };

    plugins.cmp = {
      enable = true;
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
      mini-files
    ];

  };
}
