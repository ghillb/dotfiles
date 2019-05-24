" display settings
syntax on " enable syntax highlighting
colorscheme desert " set color scheme
set background=dark " dark console background
set encoding=utf-8 " set utf8 encoding
set showmatch " highlight matching braces
let g:netrw_liststyle=3 " tree style dir mode
let g:netrw_banner=0 " hide header in dir mode

" line number settings
:set number relativenumber " set hybrid line numbers

:augroup numbertoggle " auto switch between modes on buffer focus
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

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

" misc settings
set visualbell " turn off audible bell
set nocompatible " disable vi, use vi improved
set shell=/bin/bash "set shell used by vim
set hidden " allow switching buffers without writing to disc
set wildignore=*.o,*~,*.pyc,*.pyo,__pycache__,*/venv/*

" file type specific settings
filetype on " file type detection on
filetype plugin on " load file type specific plugins 
filetype indent on " automatic code indentation

" yank buffer to system clipboard (remote / local clipboard sync)
" replace /dev/pts/1 with parrent tty
function! Osc52Yank()
    let buffer=system('base64 -w0', @0)
    let buffer=substitute(buffer, "\n$", "", "")
    let buffer='\e]52;c;'.buffer.'\x07'
    silent exe "!echo -ne ".shellescape(buffer)." > ".shellescape("/dev/pts/1")
endfunction

command! Osc52CopyYank call Osc52Yank()
augroup SyYank
    autocmd!
    autocmd TextYankPost * if v:event.operator ==# 'y' | call Osc52Yank() | endif
augroup END
