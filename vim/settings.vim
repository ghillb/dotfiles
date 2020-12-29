syntax on
set encoding=utf-8
set fileencoding=utf-8
set clipboard+=unnamedplus
set mouse=r
set backspace=indent,eol,start
set whichwrap+=<,>,h,l,[,]
set noautochdir
set confirm
set nobackup
set noswapfile
set autoindent
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set textwidth=100
set colorcolumn=+1
set formatoptions-=t
set wrap
set hlsearch
set ignorecase
set incsearch
set smartcase
set background=dark
set number relativenumber
set noshowmode
set visualbell
set splitbelow
set splitright
set showtabline=0
set updatetime=100
set undodir=$NVC/undodir
set undofile
set hidden
set wildmode=longest:full,full
set wildignore=*.o,*~,*.pyc,*.pyo,__pycache__,*/venv/*
set completeopt=menuone,noinsert,noselect
set shortmess+=c
set pastetoggle=<F3>
if !exists('g:vscode')
    set spelllang=en_us spell
endif
if has('unix')
    set shell=/bin/bash
endif

