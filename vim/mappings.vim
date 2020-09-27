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
noremap <c-\> :w<bar>so $MYVIMRC<cr>
inoremap <c-\> <esc>:w<bar>so $MYVIMRC<cr>
nnoremap <c-q> :x<cr>
noremap \ ?
nnoremap <silent><tab> :bnext<cr>
nnoremap <silent><s-tab> :bprevious<cr>
noremap <leader>bn :bnext<cr>
noremap <leader>bp :bprevious<cr>
noremap <leader>bc :enew<cr>
noremap <leader>bd :bd<cr>
noremap <leader>bl :buffers<cr>
noremap <leader>bo :w<bar>%bd<bar>e#<bar>bd#<cr>
noremap <leader>to :tabo<cr>
noremap <silent><leader>tg :set relativenumber! \| :set nu! \| :GitGutterToggle<cr>
nnoremap <silent><leader>tz :Goyo<cr>
noremap <silent><leader>tc :Codi!!<cr>
nnoremap <leader>r :%s///gc
noremap <leader>v ggVG<cr>
noremap <a-v> <esc>ggVG<cr>
nnoremap <a-j> :m .+1<cr>==
nnoremap <a-k> :m .-2<cr>==
inoremap <a-j> <esc>:m .+1<cr>==gi
inoremap <a-k> <esc>:m .-2<cr>==gi
vnoremap <a-j> :m '>+1<cr>gv=gv
vnoremap <a-k> :m '<-2<cr>gv=gv
nnoremap <a-cr> :w<cr>:call RunCode()<cr>
inoremap <a-cr> <esc>:w<cr>:call RunCode()<cr>
nmap <leader>s ysiw " surround word
nnoremap <leader>gs :G<cr>
nnoremap <leader>gd :G diff<cr>
nnoremap <leader>gc :G checkout %
nnoremap <leader>gl :Gclog<cr>
nnoremap <leader>gpl :G pull<cr>
nnoremap <leader>gps :G push<cr>
noremap <leader>u :UndotreeToggle<cr>
noremap <silent><leader>e :Fern . -drawer -toggle -reveal=%<cr>
nnoremap <silent><F12> :FloatermNew<cr>
tnoremap <silent><F12> <c-\><c-n>:FloatermKill<cr>
nnoremap <silent><leader>tt :Ttoggle<cr><c-w>wa
tnoremap <silent><leader>tt <c-\><c-n>:Ttoggle<cr>
nnoremap <silent><leader>` :T cd %:p:h <cr>:Tclear<cr><c-w>wa
nnoremap <leader><cr> :TREPLSendLine<cr>j
vnoremap <leader><cr> :TREPLSendSelection<cr>
noremap <silent><c-_> :Commentary<cr>j
inoremap <silent><c-_> <esc>:Commentary<cr>ja
nnoremap <silent><leader> :WhichKey '<space>'<cr>
noremap <silent><c-p> :Ag<cr>
noremap <silent><c-e> :call FzfOmniFiles()<cr>
noremap <silent><c-b> :Buffers<cr>
noremap <silent>? :BLines<cr>
noremap <leader><leader> :Commands<cr>
noremap <leader><bs> :FzfSwitchProject<cr>
noremap <leader>tsd "=strftime("%Y-%m-%d")<cr>P
noremap <leader>tst "=strftime("%H:%M:%S")<cr>P
noremap <leader>tsm "=strftime("%Y-%m-%d \/ %H:%M:%S")<cr>P
noremap <c-j> <c-e>
noremap <c-k> <c-y>
noremap <c-y> <c-b>
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
