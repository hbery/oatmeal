-- -*- coding: utf-8 -*-
-- vim: ts=4 : sw=4 : sts=4 : et :
-- ~~~
--     _       _ __    __
--    (_)___  (_) /_  / /_  ______ _
--   / / __ \/ / __/ / / / / / __ `/
--  / / / / / / /__ / / /_/ / /_/ /
-- /_/_/ /_/_/\__(_)_/\__,_/\__,_/
--
-- by hbery
-- ~~~

--!! ------------------------------------------------- * Required * {{{

-- Set variables
local g = vim.g
local o = vim.o
-- local hi = vim.highlight
local hi = vim.api.nvim_set_hl

-- Leader
g.mapleader = ' '
g.maplocalleader = ' '

o.compatible = false

-- }}}

--!! ---------------------------------------------- * Basic setup * {{{

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

o.incsearch = true
o.hidden = true
o.backup = false
o.swapfile = false
o.errorbells = false
o.t_Co = 256
o.number = true
o.relativenumber = true
o.clipboard = 'unnamedplus'
o.wrap = false
o.scrolloff = 12
o.sidescrolloff = 12
o.list = true
o.ttyfast = true

o.signcolumn = 'yes'
o.colorcolumn = '80'
o.cursorline = true

hi(0, 'ColorColumn', { ctermbg = 'lightgray', guibg = nil })
hi(0, 'ColorLine', { ctermbg = 'lightgray', guibg = nil })

-- Mouse mode
-- vim.o.mouse = 'nicr'
o.mouse = 'a'

-- Tabulation setup
o.breakindent = true
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smarttab = true

-- Decrease update time
o.updatetime = 250
o.timeout = true
o.timeoutlen = 300

-- More usable statusline
o.laststatus = 2
o.showmode = false
o.modeline = true
o.modelines = 2

o.exrc = true
o.guicursor = 'i:block'

-- Set completeopt to have a better completion experience
o.completeopt = 'menuone,noinsert,noselect'
o.wildmode = 'longest:full,list,full'
o.wildmenu = true

o.foldmethod = 'marker'

o.termguicolors = true

-- }}}

--!! -------------------------------------------------- * Plugins * {{{
require('lazy-plugins')
require('hbery')
-- }}}

--!! ---------------------------------------------- * Colorscheme * {{{
o.background = 'dark'

-- let g:onedark_terminal_italics = 1
-- let g:vim_monokai_tasty_italic = 1
g.gruvbox_material_background = 'soft'
g.gruvbox_material_enable_italic = 1
g.sonokai_style = 'andromeda'
g.sonokai_enable_italic = 1

--[[ colorscheme:
--     gruvbox
--     vim-monokai-tasty
--     monokai_pro
--     onedark
--     onehalfdark
--     xcodedarkhc
--     hybrid
--     molokai
--     iceberg
--     spacegray-dark
--     sonokai {'default', 'atlantis', 'andromeda', 'shusia', 'maia', 'espresso'}
--]]
vim.cmd.colorscheme 'sonokai'
hi(0, 'Normal', { guibg = nil })
hi(0, 'EndOfBuffer', { guibg = nil })
hi(0, 'Folded', { guibg = nil })
-- }}}

--!! ---------------------------------------- * All-mighty REMAPS * {{{
-- Split keys remap
vim.keymap.set('n', '<leader>v', ':vsplit<CR><C-w>l', { silent = true })
vim.keymap.set('n', '<leader>b', ':split<CR><C-w>j', { silent = true })
vim.keymap.set('n', '<C-h>', '<C-w>h', { remap = false })
vim.keymap.set('n', '<C-j>', '<C-w>j', { remap = false })
vim.keymap.set('n', '<C-k>', '<C-w>k', { remap = false })
vim.keymap.set('n', '<C-l>', '<C-w>l', { remap = false })

-- Keep block selected after indent
vim.keymap.set('v', '<', '<gv', { remap = false })
vim.keymap.set('v', '>', '>gv', { remap = false })

-- Maintain the cursor position when yanking a visual selection
vim.keymap.set('v', 'y', 'myy`y', { remap = false })
vim.keymap.set('v', 'TY', 'myY`y', { remap = false })

-- Search for visually selected text
vim.keymap.set('v', '//', "y/<C-R>=escape(@\",'/\')<CR><CR>", { remap = false })
vim.keymap.set('v', '<leader>R', "y:%s/<C-R>=escape(@\",'/\')<CR>/", { remap = false })

-- Clear search buffer
vim.keymap.set('n', '<leader>/', ':let @/=""<CR>', { remap = false, silent = true })

-- Y do as D and C (should be in neovim-core, so just to match it in vim)
-- vim.keymap.set('n', 'Y', 'y$', {remap = false})

-- Yank to system clipboard
vim.keymap.set('n', '<leader>y', '\"+y', { remap = false })
vim.keymap.set('v', '<leader>y', '\"+y', { remap = false })
vim.keymap.set('n', '<leader>Y', '\"+Y', { remap = false })

vim.keymap.set('n', '<leader>d', '\"_d', { remap = false })
vim.keymap.set('v', '<leader>d', '\"_d', { remap = false })

-- Keep me centered
vim.keymap.set('n', 'n', 'nzzzv', { remap = false })
vim.keymap.set('n', 'N', 'Nzzzv', { remap = false })
vim.keymap.set('n', 'J', 'mzJ`z', { remap = false })

-- Fix the syntax highlighting (if broken)
vim.keymap.set('n', '<leader>s', ':syntax off<CR>:syntax on<CR>', { remap = false, silent = true })

-- Move text as intended
--  in VISUAL
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { remap = false, silent = true })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { remap = false, silent = true })
--  in NORMAL
vim.keymap.set('n', '<leader>mk', ':m .-2<CR>==', { remap = false, silent = true })
vim.keymap.set('n', '<leader>mj', ':m .+1<CR>==', { remap = false, silent = true })

vim.keymap.set('i', '<A-k>', '<esc>:m .-2<CR>==gi', { remap = false, silent = true })
vim.keymap.set('i', '<A-j>', '<esc>:m .+1<CR>==gi', { remap = false, silent = true })

-- Persist yank text in paste buffer
vim.keymap.set('x', '<leader>p', '\"_dP', { remap = false })

-- Open currently edited file in the default program
vim.keymap.set('n', '<leader>x', ':!xdg-open %<CR><CR>')

-- Write as sudo
vim.keymap.set('c', 'w!!', '%!sudo tee > /dev/null %')

vim.api.nvim_create_user_command('MyWipeRegisters',
    function()
        for i = 34, 122, 1 do
            vim.fn.setreg(string.char(i), nil)
        end
    end, {})
