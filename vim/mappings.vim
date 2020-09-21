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

