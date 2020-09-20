syntax on
set shell=/bin/bash
set encoding=utf-8
set fileencoding=utf-8
set spelllang=en_us,de_de spell
set clipboard+=unnamedplus
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
set updatetime=100
set undodir=~/.vim/undodir
set undofile
set hidden
set wildmode=longest:full,full
set wildignore=*.o,*~,*.pyc,*.pyo,__pycache__,*/venv/*

let $RTP=split(&runtimepath, ',')[0]
let $RC="$HOME/.config/nvim/init.vim/"

" autoload plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" load plugins
call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'sainnhe/gruvbox-material'
Plug 'habamax/vim-gruvbit'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'idanarye/vim-merginal'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'terryma/vim-multiple-cursors'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'machakann/vim-highlightedyank'
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
Plug 'unblevable/quick-scope'
Plug 'junegunn/vim-peekaboo'
Plug 'mbbill/undotree'
Plug 'jiangmiao/auto-pairs'
Plug 'kassio/neoterm'
Plug 'voldikss/vim-floaterm'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'liuchengxu/vim-which-key'
Plug 'mhinz/vim-startify'
call plug#end()

" gitgutter config
let g:gitgutter_highlight_lines = 0
let g:gitgutter_highlight_linenrs = 1
let g:gitgutter_signs = 1
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_removed = '_'
let g:gitgutter_sign_modified = '●'
let g:gitgutter_sign_modified_removed = '⮞'
let g:gitgutter_sign_removed_first_line = '◥'
let g:gitgutter_sign_removed_above_and_below = '['
call gitgutter#highlight#define_signs()

" fzf config
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'

" vimwiki config
let g:vimwiki_list = [{
            \ 'path': '~/notes/',
            \ 'syntax': 'markdown',
            \ 'ext': '.md',
            \ 'template_path': '~/notes/templates/',
            \ 'template_default': 'default',
            \ 'path_html': '~/notes/html/',
            \ 'custom_wiki2html': 'vimwiki_markdown',
            \ 'template_ext': '.tpl',
            \ 'nested_syntaxes': {'cpp': 'cpp', 'python': 'python', 'java': 'java',
                                \ 'js': 'javascript', 'html': 'html', 'css': 'css'}}]

let g:vimwiki_table_mappings = 0
let g:vimwiki_markdown_link_ext = 0

" quick-scope
let g:qs_enable=1
" color schemes
" if has('termguicolors') | set termguicolors | endif
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection = '1'
" let g:gruvbox_material_background = 'hard'
colorscheme gruvbox
" colorscheme gruvbox-material
" colorscheme gruvbit

" layout
" disable netrw
let g:loaded_netrw  = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 25
let g:netrw_altv=1
let g:airline_theme='minimalist'

" auto-pairs config
let g:AutoPairsFlyMode = 0
let g:AutoPairsShortcutToggle = ''
let g:AutoPairsShortcutFastWrap ='' 
let g:AutoPairsShortcutJump = ''
let g:AutoPairsShortcutBackInsert = ''

" vim multi cursor mappings
let g:multi_cursor_use_default_mapping = 0
let g:multi_cursor_start_word_key      = '<A-n>'
let g:multi_cursor_select_all_word_key = '<C-n>'
let g:multi_cursor_start_key           = 'g<A-n>'
let g:multi_cursor_select_all_key      = 'g<C-n>'
let g:multi_cursor_next_key            = '<A-n>'
let g:multi_cursor_prev_key            = '<A-p>'
let g:multi_cursor_skip_key            = '<A-x>'
let g:multi_cursor_quit_key            = '<Esc>'

" neoterm settings
let g:neoterm_default_mod='belowright'
let g:neoterm_size=14
let g:neoterm_autoscroll=1

" floaterm settings
let g:floaterm_autoclose=1

" startify config
let g:startify_session_dir = '~/.vim/session'
let g:startify_custom_header = ''
let g:startify_change_to_vcs_root = 1
let g:startify_lists = [
    \ { 'header': ['   Files:'],                  'type': 'files' },
    \ { 'header': ['   CWD, '. getcwd(). ':'],    'type': 'dir' },
    \ { 'header': ['   Sessions:'],               'type': 'sessions' },
    \ { 'header': ['   Bookmarks:'],              'type': 'bookmarks' },
    \ { 'header': ['   Commands:'],               'type': 'commands' },
    \ ]

" mappings
let mapleader = " "
noremap x "_x
noremap X "_X
noremap Y y$
xnoremap p "_dP
noremap <leader>p o<Esc>p
noremap <leader>P O<Esc>p
noremap <leader>x x
noremap <leader>X X
noremap <leader>D "_D
noremap <leader>C "_C
inoremap kj <Esc>
inoremap jk <Esc>
noremap <C-\> :w <BAR> so %<CR>
noremap \ ?
noremap <leader>u :UndotreeToggle<CR>
" noremap <leader>e :Lexplore<CR>
noremap <silent><leader>e :Fern . -drawer -toggle -reveal=%<CR>
noremap <leader>bn :bnext<CR>
noremap <leader>bp :bprevious<CR>
noremap <leader>bc :enew<CR>
noremap <leader>bd :bd<CR>
noremap <leader>bl :buffers<CR>
noremap <leader>bo :w<BAR>%bd<BAR>e#<BAR>bd#<CR>
noremap <leader>to :tabo<CR>
nnoremap <silent><F12> :FloatermNew --wintype=normal --height=10<CR>
tnoremap <silent><F12> <C-\><C-n>:FloatermKill<CR>
nnoremap <silent><leader>` :Ttoggle<CR><C-w>wa
tnoremap <silent><leader>` <C-\><C-n>:Ttoggle<CR>
nnoremap <leader><CR> :TREPLSendLine<CR>j
vnoremap <leader><CR> :TREPLSendSelection<CR>
nnoremap <leader>gs :G<CR>
nnoremap <leader>gd :G diff<CR>
nnoremap <leader>gc :G add . \| G commit -m ""
nnoremap <leader>gl :Gclog<CR>
nnoremap <leader>gpl :G pull<CR>
nnoremap <leader>gps :G push<CR>
nnoremap <leader>r :%s///g
" here _ is actually /
noremap <silent> <C-_> :Commentary<CR>j
inoremap <silent> <C-_> <ESC>:Commentary<CR>ja
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
" move lines
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
" select all
noremap <A-v> <esc>ggVG<CR>
noremap <leader>v ggVG<CR>
" surround word
nmap <leader>s ysiw
" unbind arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
" fzf mappings
noremap <C-p> :Ag <CR>
noremap <C-e> :Files <CR>
noremap <C-b> :Buffers <CR>
noremap ? :BLines <CR>
" movement
noremap <C-j> <C-e>
noremap <C-k> <C-y>
noremap <C-y> <C-b>
" insert time stamps
noremap <leader>tsd "=strftime("%Y-%m-%d")<CR>P
noremap <leader>tst "=strftime("%H:%M:%S")<CR>P
noremap <leader>tsm "=strftime("%Y-%m-%d \/ %H:%M:%S")<CR>P

" toggles cursor line in insert mode
autocmd InsertEnter,InsertLeave * set cul!

" run python files with M-r
autocmd FileType python map <buffer> <M-r> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <M-r> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

" fern customization
function! s:init_fern() abort
  nmap <buffer> - <Plug>(fern-action-open:split)
  nmap <buffer> \ <Plug>(fern-action-open:vsplit)
  nmap <buffer> r <Plug>(fern-action-rename)
  nmap <buffer> m <Plug>(fern-action-move)
  nmap <buffer> c <Plug>(fern-action-copy)
  nmap <buffer> n <Plug>(fern-action-new-path)
  nmap <buffer> f <Plug>(fern-action-new-file)
  nmap <buffer> d <Plug>(fern-action-new-dir)
  nmap <buffer> s <Plug>(fern-action-hidden-toggle)
  nmap <buffer> x <Plug>(fern-action-remove)
  nmap <buffer> <space> <Plug>(fern-action-mark)
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
  autocmd BufEnter * ++nested call s:hijack_directory()
augroup END

function! s:hijack_directory() abort
  let path = expand('%:p')
  if !isdirectory(path)
    return
  endif
  bwipeout %
  execute printf('Fern %s', fnameescape(path))
endfunction
