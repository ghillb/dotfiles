set nocompatible " disable vi, use vi improved

" syntax highlighting
colorscheme desert " set color scheme
set background=dark " dark console background
syntax on " enable syntax highlighting

" display settings
set encoding=utf-8 " set utf8 encoding
set showmatch " highlight matching braces
set number " display line numbers

" write settings
set confirm " confirm dialogue for :q
set fileencoding=utf-8 " saving file in utf8
set nobackup " no backup file policy
set noswapfile " no swap file policy

" edit settings
set backspace=indent,eol,start " backspace over eol
set autoindent " automatic indentation
set expandtab " expand tabs into spaces
set shiftwidth=4 " indentation depth of 4 columns
set softtabstop=4 " backspace over 4 spaces
set textwidth=80 " wrap lines at 80th column

" search settings
set hlsearch " highlight search results
set ignorecase " case insensitive search
set incsearch " incremental search
set smartcase " no incremental search when capital letters are used

" file type specific settings
filetype on " file type detection on
filetype plugin on " load file type specific plugins 
filetype indent on " automatic code indentation
