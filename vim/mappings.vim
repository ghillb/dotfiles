let mapleader = " "
noremap x "_x
noremap X "_X
noremap Y y$
xnoremap p "_dP
noremap <leader>p o<esc>p
noremap <leader>P O<esc>p
noremap <leader>x x
noremap <leader>X X
noremap <leader>D "_D
noremap <leader>C "_C
noremap <leader>o o<esc>
noremap <leader>O O<esc>
inoremap kj <esc>
inoremap jk <esc>
noremap <C-\> :w <bar> so %<cr>
inoremap <C-\> <esc>:w <bar> so %<cr>
noremap \ ?
noremap <leader>bn :bnext<cr>
noremap <leader>bp :bprevious<cr>
noremap <leader>bc :enew<cr>
noremap <leader>bd :bd<cr>
noremap <leader>bl :buffers<cr>
noremap <leader>bo :w<bar>%bd<bar>e#<bar>bd#<cr>
noremap <leader>to :tabo<cr>
nnoremap <leader>r :%s///gc
noremap <silent><leader>tg :set relativenumber!<cr> :set nu!<cr> :GitGutterToggle<cr>
noremap <leader>v ggVG<cr>
noremap <A-v> <esc>ggVG<cr>
nnoremap <A-j> :m .+1<cr>==
nnoremap <A-k> :m .-2<cr>==
inoremap <A-j> <esc>:m .+1<cr>==gi
inoremap <A-k> <esc>:m .-2<cr>==gi
vnoremap <A-j> :m '>+1<cr>gv=gv
vnoremap <A-k> :m '<-2<cr>gv=gv
nmap <leader>s ysiw " surround word
nnoremap <leader>gs :G<cr>
nnoremap <leader>gd :G diff<cr>
nnoremap <leader>gc :G checkout %
nnoremap <leader>gl :Gclog<cr>
nnoremap <leader>gpl :G pull<cr>
nnoremap <leader>gps :G push<cr>
noremap <leader>u :UndotreeToggle<cr>
noremap <silent><leader>e :Fern . -drawer -toggle -reveal=%<cr>
nnoremap <silent><F12> :FloatermNew --wintype=normal --height=10<cr>
tnoremap <silent><F12> <C-\><C-n>:FloatermKill<cr>
nnoremap <silent><leader>` :Ttoggle<cr><C-w>wa
tnoremap <silent><leader>` <C-\><C-n>:Ttoggle<cr>
nnoremap <leader><cr> :TREPLSendLine<cr>j
vnoremap <leader><cr> :TREPLSendSelection<cr>
noremap <silent> <C-_> :Commentary<cr>j
inoremap <silent> <C-_> <esc>:Commentary<cr>ja
nnoremap <silent> <leader> :WhichKey '<space>'<cr>
noremap <C-p> :Ag<cr>
noremap <C-e> :Files<cr>
noremap <C-b> :Buffers<cr>
noremap ? :BLines<cr>
noremap <leader><bs> :FzfSwitchProject<cr>
noremap <leader>tsd "=strftime("%Y-%m-%d")<cr>P
noremap <leader>tst "=strftime("%H:%M:%S")<cr>P
noremap <leader>tsm "=strftime("%Y-%m-%d \/ %H:%M:%S")<cr>P
noremap <C-j> <C-e>
noremap <C-k> <C-y>
noremap <C-y> <C-b>
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
