-- [[ Plugins List ]]

-- Install package manager if not installed
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Plugins installation
require('lazy').setup({
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'voldikss/vim-floaterm',

  -- From the plain old vim : better edition plugins
  'tpope/vim-surround',
  { 'windwp/nvim-autopairs', opts = {} },
  'sheerun/vim-polyglot',

  -- 'preservim/nerdtree',
  'stevearc/oil.nvim',

  -- Still prefer to use NERDTree over Nvim-tree
  -- {
  --   'nvim-tree/nvim-tree.lua',
  --   opts = {
  --       sort_by = "case_sensitive",
  --       renderer = {
  --             group_empty = true,
  --       },
  --       filters = {
  --             dotfiles = true,
  --       },
  --   },
  -- },

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {}, tag = 'legacy' },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
  },

  { 'saltstack/salt-vim' },
  { 'stephpy/vim-yaml' },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  { -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- Lovely colorschemes
  { 'navarasu/onedark.nvim' },
  { 'folke/tokyonight.nvim' },
  { "catppuccin/nvim", name = "catppuccin" },
  { 'sainnhe/sonokai', priority = 1000 },
  { 'gruvbox-community/gruvbox' },

  { -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = false,
        theme = 'powerline',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  { 'numToStr/Comment.nvim', opts = {} },

  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  },

  -- Little practice
  'ThePrimeagen/vim-be-good',
}, {})

