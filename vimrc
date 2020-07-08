" display settings
syntax on " enable syntax highlighting
set background=dark 
set encoding=utf-8 
set showmatch 
set number relativenumber 
set noshowmode
"set noshowcmd

" write settings
set confirm " confirm dialogue for :q
set fileencoding=utf-8 " saving file in utf8
set nobackup " no backup file policy
set noswapfile " no swap file policy

" edit settings
set backspace=indent,eol,start " backspace over eol
set autoindent 
set expandtab " expand tabs into spaces
set tabstop=4 
set shiftwidth=4 
set softtabstop=4 
set textwidth=80
	
" search settings
set hlsearch " highlight search results
set ignorecase " case insensitive search
set incsearch " incremental search
set smartcase " no incremental search when capital letters are used

" misc settings
set visualbell " turn off audible bell
set shell=/bin/bash 
set hidden " allow switching buffers without writing to disc
set wildignore=*.o,*~,*.pyc,*.pyo,__pycache__,*/venv/*
set paste " turn off autoindent when pasting (set noai alternative)
set undodir=~/.vim/undodir
set undofile

" autoload plugin manager
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" plugin manager
call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'terryma/vim-multiple-cursors'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

" color scheme
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection = '1'
colorscheme gruvbox

" behaviour
if executable('rg')
    let g:rg_derive_root='true'
endif

let loaded_matchparen = 1
let mapleader = " "
let g:netrw_browse_split = 2
let g:vrfr_rg = 'true'
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:airline_theme='minimalist'
"let g:airline_statusline_ontop=1

let g:multi_cursor_use_default_mapping=0

" Default mapping
let g:multi_cursor_start_word_key      = '<A-n>'
let g:multi_cursor_select_all_word_key = '<C-n>'
let g:multi_cursor_start_key           = 'g<A-n>'
let g:multi_cursor_select_all_key      = 'g<C-n>'
let g:multi_cursor_next_key            = '<A-n>'
let g:multi_cursor_prev_key            = '<A-p>'
let g:multi_cursor_skip_key            = '<A-x>'
let g:multi_cursor_quit_key            = '<Esc>'


" mappings
let mapleader = " "
noremap x "_x
noremap X "_X
noremap <leader>x x
noremap <leader>X X
noremap <leader>d "_dd
noremap <leader>D "_D

autocmd FileType python map <buffer> <M-r> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <M-r> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

