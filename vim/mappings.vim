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
inoremap kj <esc>
inoremap jk <esc>
noremap <C-\> :w <bar> so %<cr>
inoremap <C-\> <esc>:w <bar> so %<cr>
noremap \ ?
noremap <leader>u :UndotreeToggle<cr>
" noremap <leader>e :Lexplore<cr>
noremap <silent><leader>e :Fern . -drawer -toggle -reveal=%<cr>
noremap <leader>bn :bnext<cr>
noremap <leader>bp :bprevious<cr>
noremap <leader>bc :enew<cr>
noremap <leader>bd :bd<cr>
noremap <leader>bl :buffers<cr>
noremap <leader>bo :w<bar>%bd<bar>e#<bar>bd#<cr>
noremap <leader>to :tabo<cr>
nnoremap <silent><F12> :FloatermNew --wintype=normal --height=10<cr>
tnoremap <silent><F12> <C-\><C-n>:FloatermKill<cr>
nnoremap <silent><leader>` :Ttoggle<cr><C-w>wa
tnoremap <silent><leader>` <C-\><C-n>:Ttoggle<cr>
nnoremap <leader><cr> :TREPLSendLine<cr>j
vnoremap <leader><cr> :TREPLSendSelection<cr>
nnoremap <leader>gs :G<cr>
nnoremap <leader>gd :G diff<cr>
nnoremap <leader>gc :G add . \| G commit -m ""
nnoremap <leader>gl :Gclog<cr>
nnoremap <leader>gpl :G pull<cr>
nnoremap <leader>gps :G push<cr>
nnoremap <leader>r :%s///g
" here _ is actually /
noremap <silent> <C-_> :Commentary<cr>j
inoremap <silent> <C-_> <esc>:Commentary<cr>ja
nnoremap <silent> <leader> :WhichKey '<space>'<cr>
" move lines
nnoremap <A-j> :m .+1<cr>==
nnoremap <A-k> :m .-2<cr>==
inoremap <A-j> <esc>:m .+1<cr>==gi
inoremap <A-k> <esc>:m .-2<cr>==gi
vnoremap <A-j> :m '>+1<cr>gv=gv
vnoremap <A-k> :m '<-2<cr>gv=gv
" select all
noremap <A-v> <esc>ggVG<cr>
noremap <leader>v ggVG<cr>
" surround word
nmap <leader>s ysiw
" unbind arrow keys
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
" fzf mappings
noremap <C-p> :Ag<cr>
noremap <C-e> :Files<cr>
noremap <C-b> :Buffers<cr>
noremap ? :BLines<cr>
noremap <leader><bs> :FzfSwitchProject<cr>
" movement
noremap <C-j> <C-e>
noremap <C-k> <C-y>
noremap <C-y> <C-b>
" insert time stamps
noremap <leader>tsd "=strftime("%Y-%m-%d")<cr>P
noremap <leader>tst "=strftime("%H:%M:%S")<cr>P
noremap <leader>tsm "=strftime("%Y-%m-%d \/ %H:%M:%S")<cr>P

