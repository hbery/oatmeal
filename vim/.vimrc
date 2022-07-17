" -*- coding: utf-8 -*-
" vim: :
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
    Plug 'scrooloose/nerdtree'
    Plug 'voldikss/vim-floaterm'
    if !has('nvim')
        Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
        Plug 'junegunn/fzf.vim'
    endif

    if has('nvim')
        Plug 'wbthomason/packer.nvim'
        Plug 'nvim-treesitter/nvim-treesitter'
        Plug 'nvim-treesitter/playground'
        Plug 'nvim-telescope/telescope.nvim'
        " for telescope :/
        Plug 'nvim-lua/popup.nvim'
        Plug 'nvim-lua/plenary.nvim'
        Plug 'nvim-telescope/telescope-fzy-native.nvim'
        Plug 'ThePrimeagen/git-worktree.nvim'
    endif
    " nvim remote edit (nah, thought it was different)
    " has('nvim')
    "   Plug 'chipsenkbeil/distant.nvim'
    " endif

    "" statusline / startup / additional look
    Plug 'itchyny/lightline.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'ryanoasis/vim-devicons'
    Plug 'junegunn/vim-emoji'

    "" editor
    Plug 'tpope/vim-surround'
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}
    Plug 'frazrepo/vim-rainbow'
    Plug 'jiangmiao/auto-pairs'
    Plug 'sheerun/vim-polyglot'

    "" git 
    " Plug 'airblade/vim-gitgutter'
    Plug 'jreybert/vimagit'
    Plug 'tpope/vim-fugitive'

    "" engines / engine-related
    " Plug 'w0rp/ale'
    Plug 'davidhalter/jedi-vim'

    if has('nvim')
        Plug 'neovim/nvim-lspconfig'
        Plug 'hrsh7th/cmp-nvim-lsp'
        Plug 'hrsh7th/cmp-buffer'
        Plug 'hrsh7th/nvim-cmp'
        Plug 'prabirshrestha/vim-lsp'
        Plug 'mattn/vim-lsp-settings'
    endif

    "" informational
    Plug 'tpope/vim-commentary'
    Plug 'vimwiki/vimwiki'
    Plug 'liuchengxu/vim-which-key'

    "" style
    Plug 'junegunn/goyo.vim'
    Plug 'junegunn/limelight.vim'

    if has('nvim')
        Plug 'startup-nvim/startup.nvim'
    endif

    "" tmux
    Plug 'tmux-plugins/vim-tmux'

    "" language support
    Plug 'vim-perl/vim-perl'
    Plug 'vim-python/python-syntax'
    Plug 'rust-lang/rust.vim'
    Plug 'fatih/vim-go'
    Plug 'momota/cisco.vim'
    Plug 'lervag/vimtex'
    " Plug 'vim-latex/vim-latex'
    " Plug 'tbastos/vim-lua'
    Plug 'ap/vim-css-color'

    " if has('nvim')
    "     Plug 'nvim-neorg/neorg'
    " endif

    "" colorschemes
    Plug 'gruvbox-community/gruvbox'
    Plug 'patstockwell/vim-monokai-tasty'
    Plug 'arzg/vim-colors-xcode'
    Plug 'joshdick/onedark.vim'
    Plug 'w0ng/vim-hybrid'
    Plug 'sainnhe/sonokai'
    Plug 'cocopon/iceberg.vim'
    Plug 'sainnhe/gruvbox-material'
    Plug 'sonph/onehalf', {'rtp': 'vim/'}
    Plug 'tomasr/molokai'
    Plug 'yuttie/sublimetext-spacegray.vim'

    if has('nvim')
        Plug 'tanvirtin/monokai.nvim'
    endif

    "" lemme play with it
    if has('nvim')
        Plug 'ThePrimeagen/vim-be-good'
    endif

call plug#end()
" }}}

"!! ---------------------------------------------- * Colorscheme * {{{

set background=dark

" let g:onedark_terminal_italics = 1
" let g:vim_monokai_tasty_italic = 1
let g:gruvbox_material_background = 'soft'
let g:gruvbox_material_enable_italic = 1
let g:sonokai_style = 'andromeda'
let g:sonokai_enable_italic = 1

" colorscheme:
"  \ gruvbox
"  \ vim-monokai-tasty
"  \ monokai_pro
"  \ onedark
"  \ onehalfdark
"  \ xcodedarkhc
"  \ hybrid
"  \ molokai
"  \ iceberg
"  \ spacegray-dark
"  \ sonokai {'default', 'atlantis', 'andromeda', 'shusia', 'maia', 'espresso'}
if !has('nvim')
    colorscheme gruvbox-material
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
map <C-t> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable='►'
let g:NERDTreeDirArrowCollapsible='▼'
let NERDTreeShowLineNumbers=1
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let g:NERDTreeWinSize=35

" Rainbow plugin settings
let g:rainbow_active = 1

" Python settings
let g:python_highlight_all = 1

"=!= ALE settings (inactive when LSP is on)
if !has('nvim')
    let g:ale_lint_on_save = 1
    let g:ale_linters = {"python": ['flake8']}
    let g:ale_fixers = {'*': [], 'python':['black']}
endif

if has('nvim')
    " WhichKey
    set timeoutlen=500

    "=!= Load LUA plugins and configs
    lua require('packer-plugins')
    lua require('hbery')

    "=!= LSP settings {{{
    if executable('pyls')
        au User lsp_setup call lsp#register_server({
            \ 'name': 'pyls',
            \ 'cmd': {server_info->['pyls']},
            \ 'allowlist': ['python'],
            \ 'settings': {
            \    'pyls':
            \        {'configurationSources': ['flake8', 'pycodestyle'],
            \         'plugins': {'flake8': {'enabled': v:true},
            \                     'pyflakes': {'enabled': v:false},
            \                     'pycodestyle': {'enabled': v:true},
            \                    }
            \       }
            \ }})
    endif

    function! s:on_lsp_buffer_enabled() abort
        setlocal omnifunc=lsp#complete
        setlocal signcolumn=yes
        if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
        nmap <buffer> gd <plug>(lsp-definition)
        nmap <buffer> gs <plug>(lsp-document-symbol-search)
        nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
        nmap <buffer> gr <plug>(lsp-references)
        nmap <buffer> gi <plug>(lsp-implementation)
        nmap <buffer> gt <plug>(lsp-type-definition)
        nmap <buffer> <leader>rn <plug>(lsp-rename)
        nmap <buffer> [g <plug>(lsp-previous-diagnostic)
        nmap <buffer> ]g <plug>(lsp-next-diagnostic)
        nmap <buffer> K <plug>(lsp-hover)
        inoremap <buffer> <expr><c-f> lsp#scroll(+4)
        inoremap <buffer> <expr><c-d> lsp#scroll(-4)

        let g:lsp_format_sync_timeout = 1000
        autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    endfunction

    augroup lsp_install
        au!
        autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
    augroup END
" }}}

endif

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
