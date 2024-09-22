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
local hi = vim.api.nvim_set_hl
local kms = vim.keymap.set

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
o.number = true
o.relativenumber = true
o.clipboard = 'unnamedplus'
o.wrap = false
o.scrolloff = 12
o.sidescrolloff = 12
o.list = true
o.ttyfast = true

o.signcolumn = 'yes'
o.colorcolumn = '120'
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
--      onedark { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light' }
--      tokyonight { '-night', '-storm', '-day', '-moon' }
--      catppuccin { '-latte', '-frappe', '-macchiato', '-mocha' }
--      sonokai { 'default', 'atlantis', 'andromeda', 'shusia', 'maia', 'espresso' }
--      gruvbox -- { tooooo many! } --
--]]
vim.cmd.colorscheme 'catppuccin-macchiato'
hi(0, 'Normal', { guibg = nil })
hi(0, 'EndOfBuffer', { guibg = nil })
hi(0, 'Folded', { guibg = nil })
-- }}}

--!! ---------------------------------------- * All-mighty REMAPS * {{{
-- Split keys remap
kms('n', '<leader>v', ':vsplit<CR><C-w>l', { silent = true, desc = "Split buffer vertically" })
kms('n', '<leader>b', ':split<CR><C-w>j', { silent = true, desc = "Split buffer horizontally" })

-- Filesystem navigation `oil.nvim`
kms("n", "-", require("oil").open, { desc = "Open parent directory" })

-- Terminal toggling
kms("n", "<leader>T", ':FloatermToggle<CR>', { silent = true, remap = false, desc = "Toggle Floating terminal" })
kms("n", "<leader>tt", ':terminal<CR>', { silent = true, remap = false, desc = "Open terminal in current window" })
kms("n", "<leader>tb", ':split<CR><C-w>j:terminal<CR>', { silent = true, remap = false, desc = "Open terminal down from current window" })
kms("n", "<leader>tv", ':vsplit<CR><C-w>l:terminal<CR>', { silent = true, remap = false, desc = "Open terminal next to current window" })

-- Keep block selected after indent
kms('v', '<', '<gv', { remap = false, desc = "Deindent selected block keeping it selected" })
kms('v', '>', '>gv', { remap = false, desc = "Indent selected block keeping it selected"  })

-- Maintain the cursor position when yanking a visual selection
kms('v', 'y', 'myy`y', { remap = false, desc = "Yank visual selection maintaining last cursor position" })
kms('v', 'Y', 'myY`y', { remap = false, desc = "Yank lines in visual selection maintaining last cursor position" })

-- Search for visually selected text
kms('v', '//', "y/<C-R>=escape(@\",'/\')<CR><CR>", { remap = false, desc = "Search for visually selected string" })
kms('v', '<leader>R', "y:%s/<C-R>=escape(@\",'/\')<CR>/", { remap = false, desc = "Replace visually selected word" })

-- Clear search buffer
kms('n', '<leader>S', ':let @/=""<CR>', { remap = false, silent = true, desc = "Clear search buffer" })

-- Y do as D and C (should be in neovim-core, so just to match it in vim)
-- kms('n', 'Y', 'y$', {remap = false})

-- Yank to system clipboard
kms('n', '<leader>y', '\"+yy', { remap = false, desc = "Yank line to clipboard" })
kms('v', '<leader>y', '\"+y', { remap = false, desc = "Yank selection to clipboard" })
kms('n', '<leader>Y', '\"+Y', { remap = false, desc = "Yank till the end of the line to clipboard" })

kms('n', '<leader>d', '\"_d', { remap = false, desc = "Delete to oblivion" })
kms('v', '<leader>d', '\"_d', { remap = false, desc = "Delete selection to oblivion" })

-- Keep me centered
kms('n', 'n', 'nzzzv', { remap = false, desc = "Next occurence in the center of the screen" })
kms('n', 'N', 'Nzzzv', { remap = false, desc = "Previous occurence in the center of the screen" })
kms('n', 'J', 'mzJ`z', { remap = false, desc = "Join lines, without moving cursor" })

-- Fix the syntax highlighting (if broken)
kms('n', '<leader>s', ':syntax off<CR>:syntax on<CR>', { remap = false, silent = true, desc = "Retoggle syntax" })

-- Move text as intended
--  in VISUAL
kms('v', 'K', ":m '<-2<CR>gv=gv", { remap = false, silent = true, desc = "Move selected lines UP" })
kms('v', 'J', ":m '>+1<CR>gv=gv", { remap = false, silent = true, desc = "Move selected lines DOWN"  })
--  in NORMAL
kms('n', '<leader>mk', ':m .-2<CR>==', { remap = false, silent = true, desc = "Move highlighted line UP" })
kms('n', '<leader>mj', ':m .+1<CR>==', { remap = false, silent = true, desc = "Move highlighted line DOWN" })
-- in INSERT
kms('i', '<A-k>', '<esc>:m .-2<CR>==gi', { remap = false, silent = true, desc = "Move edited line UP" })
kms('i', '<A-j>', '<esc>:m .+1<CR>==gi', { remap = false, silent = true, desc = "Move edited line DOWN" })

-- Persist yank text in paste buffer
kms('x', '<leader>p', '\"_dP', { remap = false, desc = "Paste yanked text from buffer, don't replace" })

-- Open currently edited file in the default program
kms('n', '<leader>x', ':!xdg-open %<CR><CR>', { silent = true, desc = "Open with xdg-open" })
kms("n", "<leader>X", '<cmd>!chmod u+x %<CR>', { silent = true, desc = "Chmod the current file to be executable" })

-- Write as sudo
kms('c', 'w!!', '%!sudo tee > /dev/null %', { silent = true, desc = "Save this file as sudo" })

vim.api.nvim_create_user_command('MyWipeRegisters',
    function()
        for i = 34, 122, 1 do
            vim.fn.setreg(string.char(i), nil)
        end
    end, {})
