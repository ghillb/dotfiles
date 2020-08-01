syntax on
set background=dark 
set encoding=utf-8 
set number relativenumber 
set noshowmode
"set noshowcmd
set spelllang=en_us,de_de spell

set confirm
set fileencoding=utf-8
set nobackup
set noswapfile
set clipboard+=unnamedplus

set backspace=indent,eol,start
set autoindent 
set expandtab 
set tabstop=4 
set shiftwidth=4 
set softtabstop=4 
set textwidth=80

set hlsearch
set ignorecase 
set incsearch
set smartcase

set visualbell
set shell=/bin/bash 
set hidden
set wildignore=*.o,*~,*.pyc,*.pyo,__pycache__,*/venv/*
set undodir=~/.vim/undodir
set undofile
set updatetime=100

" autoload plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" load plugins
call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'terryma/vim-multiple-cursors'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'vimwiki/vimwiki'
call plug#end()

" gitgutter config
let g:gitgutter_highlight_lines = 0
let g:gitgutter_highlight_linenrs = 1
let g:gitgutter_signs = 1
let g:gitgutter_sign_added = '✚'
let g:gitgutter_sign_removed = '✘'
let g:gitgutter_sign_modified = '❖'
let g:gitgutter_sign_modified_removed = '⮞'
let g:gitgutter_sign_removed_first_line = '◥'
let g:gitgutter_sign_removed_above_and_below = '['
call gitgutter#highlight#define_signs()

" fzf config
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'

" vimwiki config
let notes_md = {'path': '~/notes/md/', 'syntax': 'markdown', 'ext': '.md'}
let notes_wiki = {'path': '~/notes/wiki/'}
let g:vimwiki_list = [notes_md, notes_wiki]

" color scheme
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection = '1'
colorscheme gruvbox

" layout
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 2
let g:netrw_winsize = 25
let g:airline_theme='minimalist'
"let g:airline_statusline_ontop=1

" vim surround mappings
let g:multi_cursor_use_default_mapping = 0
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
noremap D "_D
noremap <leader>x x
noremap <leader>X X
noremap <leader>D D
noremap ? :help<CR>
noremap \ :so %<CR>
xnoremap p "_dP
" move lines
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
" select all
map <A-v> <esc>ggVG<CR>
nmap <leader>v ggVG<CR>
" surround word
nmap <leader>s ysiw
" unbind arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
" fzf find window
noremap <C-F> :Rg <CR>

" toogles cursor line in insert mode
autocmd InsertEnter,InsertLeave * set cul!

" run python files wth M-r
autocmd FileType python map <buffer> <M-r> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <M-r> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

