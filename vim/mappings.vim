let mapleader = " "
no x "_x
no X "_X
no Y y$
xn p "_dP
ino kj <esc>
ino jk <esc>
no <c-s> :w<cr>
" ino <c-s> <esc>:w<cr>
nn <c-q> :x<cr>
ino <c-q> <esc>:x<cr>
ino <c-d> <c-r>=expand('%:p:h').'/'<cr>
no <c-\> :%s/\s\+$//e<cr>
nn <silent><tab> :bnext<cr>
nn <silent><s-tab> :bprevious<cr>
vn <silent>al :<c-u>normal 0v$h<CR>
om <silent>al :normal val<CR>
vn <silent>il :<c-u>normal ^vg_<CR>
om <silent>il :normal vil<CR>
vn <silent> a` :<c-u>call Ticks(0)<cr>
vn <silent> i` :<c-u>call Ticks(1)<cr>
ono <silent> a` :<c-u>normal va`<cr>
ono <silent> i` :<c-u>normal vi`<cr>
nn <a-down> :m .+1<cr>==
nn <a-up> :m .-2<cr>==
vn <a-down> :m '>+1<cr>gv=gv
vn <a-up> :m '<-2<cr>gv=gv
ino <a-down> <esc>:m .+1<cr>==gi
ino <a-up> <esc>:m .-2<cr>==gi
nn <a-cr> :w<cr>:call RunCode()<cr>
ino <a-cr> <esc>:w<cr>:call RunCode()<cr>
nn <silent><F12> :FloatermNew<cr>
tno <silent><F12> <c-\><c-n>:FloatermKill<cr>
no <c-j> <c-e>
no <c-k> <c-y>
no <c-y> <c-b>
no <up> <nop>
no <down> <nop>
no <left> <nop>
no <right> <nop>
nn <silent><c-p> :Ag<cr>
nn <silent><c-e> :call FzfOmniFiles()<cr>
nn <silent><c-b> :Buffers<cr>
nn <silent>\ :BLines<cr>
nn <silent>\| :Lines<cr>
nn <leader><leader> :Commands<cr>
nn <leader><bs> :FzfSwitchProject<cr>
no <leader>p o<esc>p
no <leader>P O<esc>p
no <leader>x x
no <leader>X X
no <leader>D "_D
no <leader>C "_C
nn <leader>o o<esc>
nn <leader>O O<esc>
nn <leader>,, :e $MYVIMRC<cr>
nn <leader>,. :so $MYVIMRC<cr>
nn <leader>bn :bnext<cr>
nn <leader>bp :bprevious<cr>
nn <leader>bc :enew<cr>
nn <leader>bd :bd<cr>
nn <leader>bl :buffers<cr>
nn <leader>bo :w<bar>%bd<bar>e#<bar>bd#<cr>
nn <leader>to :tabo<cr>
nn <silent><leader>tg :set rnu! \| :set nu! \| :GitGutterToggle<cr>
nn <leader>tz :Goyo<cr>
nn <leader>tc :Codi!!<cr>
nn <leader>r :%s///gc
nn <leader>v ggVG<cr>
nm <leader>s ysiw
nn <leader>gs :G<cr>
nn <leader>gd :Gvdiffsplit<cr>
nn <leader>gc :G checkout %
nn <leader>gl :Gclog<cr>
nn <leader>gpl :G pull<cr>
nn <leader>gps :G push<cr>
nn <leader>gb :MerginalToggle<cr>
nn <leader>ga :G add -p<cr>
nn <leader>gm :Gblame<cr>
nn <leader>u :UndotreeToggle<cr>
nn <silent><leader>e :Fern . -drawer -toggle -reveal=%<cr>
nn <silent><leader>tt :Ttoggle<cr><c-w>wa
tno <silent><leader>tt <c-\><c-n>:Ttoggle<cr>
nn <silent><leader>` :T cd %:p:h <cr>:Tclear<cr><c-w>wa
nn <leader><cr> :TREPLSendLine<cr>j
vn <leader><cr> :TREPLSendSelection<cr>
no <silent><c-_> :Commentary<cr>j
ino <silent><c-_> <esc>:Commentary<cr>ja
nn <silent><leader> :WhichKey '<space>'<cr>
no <leader>tsd "=strftime("%Y-%m-%d")<cr>P
no <leader>tst "=strftime("%H:%M:%S")<cr>P
no <leader>tsm "=strftime("%Y-%m-%d \/ %H:%M:%S")<cr>P

