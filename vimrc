" display settings
syntax on " enable syntax highlighting
set background=dark 
set encoding=utf-8 
set showmatch 
set number relativenumber 

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
set nocompatible " disable vi, use vi improved
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
Plug 'terryma/vim-multiple-cursors'
call plug#end()

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

" mappings
map x "_x
map X "_D
map <C-x> "_dd

autocmd FileType python map <buffer> <M-r> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <M-r> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

