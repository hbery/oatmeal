" -*- coding: utf-8 -*-
" vim: ts=4 : sts=4 : sw=4 : et :
" ~~~
"           _                        __   _       _ __        _
"    _   __(_)___ ___  __________   / /  (_)___  (_) /__   __(_)___ ___
"   | | / / / __ `__ \/ ___/ ___/  / /  / / __ \/ / __/ | / / / __ `__ \
"  _| |/ / / / / / / / /  / /__   / /  / / / / / / /__| |/ / / / / / / /
" (_)___/_/_/ /_/ /_/_/   \___/  / /  /_/_/ /_/_/\__(_)___/_/_/ /_/ /_/
"                               /_/
" by hbery
" ~~~


"!! ------------------------------------------------- * Required * {{{

" Leader
let mapleader = ' '
let maplocalleader = '\\'

set nocompatible
filetype off
filetype plugin indent on
" }}}

"!! ---------------------------------------------- * Basic setup * {{{
set path+=*
set incsearch
set hidden
set nobackup
set noswapfile
set noerrorbells
set t_Co=256
set number relativenumber
set clipboard=unnamedplus
set nowrap
set scrolloff=12
set sidescrolloff=12
set list
syntax enable
syntax on

" Mark 80 column
set signcolumn=yes
set colorcolumn=80
set cursorline
if !has('nvim')
    highlight ColorColumn ctermbg=lightgray guibg=NONE
    highlight CursorLine ctermbg=lightgray guibg=NONE
else
    highlight ColorColumn ctermbg=lightgray guibg=none
    highlight CursorLine ctermbg=lightgray guibg=none
endif

" Mouse scrolling
" set mouse=nicr
set mouse=a

" Tabulation setup
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

" Line folding
" set foldmethod=indent
" set foldlevel=99

" Make statusline more usable
set laststatus=2
set noshowmode
set modeline
set modelines=2

" Neovim specific variables
set exrc
set guicursor=i:block
" set termguicolors
set completeopt=menuone,noinsert,noselect
set wildmode=longest:full,list,full
set wildmenu

" Set folding
set foldmethod=marker

" }}}

"!! ---------------------------------------------- * Tmux checks * {{{
if empty($TMUX)
  if has('nvim')
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
endif

if has('termguicolors')
    set termguicolors
endif

" }}}

"!! ----------------------------------- * Autoinstall `vim-plug` * {{{
if !has('nvim')
    set runtimepath^=~/.config/vim
endif

let data_dir = has('nvim') ? '~/.config/nvim' : '~/.config/vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}

"!! -------------------------------------------------- * Plugins * {{{

if !has('nvim')
call plug#begin("~/.config/vim/plugged")
else
call plug#begin("~/.config/nvim/plugged")
endif

    "" file manager / finder
    " Plug 'scrooloose/nerdtree'
    Plug 'tpope/vim-vinegar'

    Plug 'voldikss/vim-floaterm'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    "" statusline / startup / additional look
    Plug 'itchyny/lightline.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'ryanoasis/vim-devicons'
    Plug 'junegunn/vim-emoji'

    "" editor
    Plug 'tpope/vim-surround'
    Plug 'mg979/vim-visual-multi', { 'branch': 'master' }
    Plug 'frazrepo/vim-rainbow'
    Plug 'jiangmiao/auto-pairs'
    Plug 'sheerun/vim-polyglot'

    "" git
    Plug 'tpope/vim-fugitive'

    "" informational
    Plug 'tpope/vim-commentary'
    Plug 'vimwiki/vimwiki'
    Plug 'liuchengxu/vim-which-key'

    "" style
    Plug 'junegunn/goyo.vim'
    Plug 'junegunn/limelight.vim'

    "" tmux
    Plug 'tmux-plugins/vim-tmux'

    "" language support
    Plug 'vim-perl/vim-perl'
    Plug 'vim-python/python-syntax'
    Plug 'rust-lang/rust.vim'
    Plug 'fatih/vim-go'
    Plug 'ap/vim-css-color'

    "" colorschemes
    Plug 'gruvbox-community/gruvbox'
    Plug 'sainnhe/sonokai'
    Plug 'catppuccin/vim', { 'as': 'catppuccin' }

call plug#end()
" }}}

"!! ---------------------------------------------- * Colorscheme * {{{

set background=dark

let g:sonokai_style = 'andromeda'
let g:sonokai_enable_italic = 1

" colorscheme:
"  \ gruvbox
"  \ sonokai {'default', 'atlantis', 'andromeda', 'shusia', 'maia', 'espresso'}
"  \ catppuccin_ {'macchiato', 'mocha', 'frappe', 'latte'}
if !has('nvim')
    colorscheme catppuccin_macchiato
    highlight Normal guibg=NONE
    highlight EndOfBuffer guibg=NONE
else
    colorscheme sonokai
    highlight Normal guibg=none
    highlight EndOfBuffer guibg=none
    highlight Folded guibg=none
endif
" }}}

"!! ------------------------------------------ * Plugin settings * {{{

"=!= Statusline settings {{{
""" lightline (uncomment to disable)
" let g:loaded_lightline = 1

""" airline (uncomment to disable)
let g:loaded_airline = 1

" Lightline specific
" let g:lightline = { 'colorscheme': 'monokai_tasty' }
" let g:lightline = { 'colorscheme': 'onedark' }
let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" Airline specific
" let g:airline_theme='monokai_tasty'
" let g:airline_theme='onedark'
let g:airline_theme='powerline'

" let g:airline_powerline_fonts = 1

" if !exists('g:airline_symbols')
"   let g:airline_symbols = {}
" endif

" let g:airline_left_sep = ''
" let g:airline_left_alt_sep = ''
" let g:airline_right_sep = ''
" let g:airline_right_alt_sep = ''
" let g:airline_symbols.branch = ''
" let g:airline_symbols.colnr = ' :'
" let g:airline_symbols.readonly = ''
" let g:airline_symbols.linenr = ' :'
" let g:airline_symbols.maxlinenr = '☰ '
" let g:airline_symbols.dirty='⚡'

"=!= END Statusline }}}

"=!= Limelight & Goyo {{{

" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240

" Color name (:help gui-colors) or RGB color
let g:limelight_conceal_guifg = 'DarkGray'
let g:limelight_conceal_guifg = '#777777'

" Default: 0.5
let g:limelight_default_coefficient = 0.7

" Number of preceding/following paragraphs to include (default: 0)
let g:limelight_paragraph_span = 1

" Beginning/end of paragraph
"   When there's no empty line between the paragraphs
"   and each paragraph starts with indentation
let g:limelight_bop = '^\s'
let g:limelight_eop = '\ze\n^\s'

" Highlighting priority (default: 10)
"   Set it to -1 not to overrule hlsearch
let g:limelight_priority = -1

autocmd! User GoyoEnter Limelight
" autocmd! User GoyoLeave Limelight!
if has('nvim')
    autocmd! User GoyoLeave
        \ Limelight! |
        \ highlight Normal guibg=none
else
    autocmd! User GoyoLeave
        \ Limelight! |
        \ highlight Normal guibg=NONE
endif
"}}}

"=!= NerdTree settings
" map <C-t> :NERDTreeToggle<CR>
" let g:NERDTreeDirArrowExpandable='►'
" let g:NERDTreeDirArrowCollapsible='▼'
" let NERDTreeShowLineNumbers=1
" let NERDTreeShowHidden=1
" let NERDTreeMinimalUI=1
" let g:NERDTreeWinSize=35

" Rainbow plugin settings
let g:rainbow_active = 1

" Python settings
let g:python_highlight_all = 1
" }}}

"!! ---------------------------------------- * All-mighty REMAPS * {{{
" Split keys remap
map <silent> <leader>v :vsplit<CR><C-w>l
map <silent> <leader>b :split<CR><C-w>j
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Goyo
nnoremap <silent> <leader>G <

" Keep block selected after indent
vnoremap < <gv
vnoremap > >gv

" Maintain the cursor position when yanking a visual selection
vnoremap y myy`y
vnoremap TY myY`y

" Search for visually selected text
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" Clear search buffer
nnoremap <leader>/ :let @/=""<CR>

" Y do as D and C (should be in neovim-core, so just to match it in vim)
nnoremap Y y$

" Keep me centered
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Fix the syntax highlighting (if broken)
nnoremap <silent> <leader>s :syntax off<CR>:syntax on<CR>

" Move text as intended
"  in VISUAL
vnoremap <silent> K :m '<-2<CR>gv=gv
vnoremap <silent> J :m '>+1<CR>gv=gv
"  in NORMAL
nnoremap <silent> <leader>mk :m .-2<CR>==
nnoremap <silent> <leader>mj :m .+1<CR>==

if !has('nvim')
    " Does not work in every terminal
    execute "set <M-j>=\ej"
    execute "set <M-k>=\ek"
    inoremap <M-k> <esc>:m .-2<CR>==gi
    inoremap <M-j> <esc>:m .+1<CR>==gi
else
    inoremap <A-k> <esc>:m .-2<CR>==gi
    inoremap <A-j> <esc>:m .+1<CR>==gi
endif

" Open currently edited file in the default program
nmap <leader>x :!xdg-open %<CR><CR>

" Write as sudo
cmap w!! %!sudo tee > /dev/null %

if !has('nvim')
    " Fzf maps
    nnoremap <leader>ps :Rg<CR>
    nnoremap <Leader>pf :Files<CR>
    nnoremap <leader>pg :GFiles<CR>
    nnoremap <Leader>pc :Commands<CR>
    nnoremap <Leader>ph :Helptags<CR>
else
    " Telescope maps
    nnoremap <leader>ps :lua require('telescope.builtin').grep_string({
        \ search = vim.fn.input("Grep For > ")
        \ })<CR>
    nnoremap <Leader>pf :lua require('telescope.builtin').find_files()<CR>
    nnoremap <leader>pg :lua require('telescope.builtin').git_files()<CR>
    nnoremap <Leader>pc :lua require('telescope.builtin').commands()<CR>
    nnoremap <Leader>ph :lua require('telescope.builtin').help_tags()<CR>
endif

" WhichKey
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

" }}}
