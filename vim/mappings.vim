let mapleader = " "
no x "_x
no X "_X
no Y yg_
no vv V
no V vg_
xn <silent> p p:let @+=@0<CR>:let @"=@0<CR>
xn <silent> P P:let @+=@0<CR>:let @"=@0<CR>
ino kj <esc>
ino jk <esc>
no <c-s> :w<cr>
ino <c-s> <esc>:w<cr>
nn <c-q> :x<cr>
ino <c-q> <esc>:x<cr>
ino <c-d> <c-r>=expand('%:p:h').'/'<cr>
no <c-\> :%s/\s\+$//e<cr>
vn / y/\V<C-R>=escape(@",'/\')<CR><CR>N
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
no <c-j> <c-e>
no <c-k> <c-y>
no <c-y> <c-b>
nn <silent> <a-h> :call TmuxMove('h')<cr>
nn <silent> <a-j> :call TmuxMove('j')<cr>
nn <silent> <a-k> :call TmuxMove('k')<cr>
nn <silent> <a-l> :call TmuxMove('l')<cr>
map - <c-w>-
map = <c-w>+
im <c-w> <c-o><c-w>
tno <c-w> <c-\><c-n><c-w>
no <up> <nop>
no <down> <nop>
no <left> <nop>
no <right> <nop>
nn <silent><c-p> :Ag<cr>
nn <silent><c-e> :call FzfOmniFiles()<cr>
nn <silent><c-b> :Buffers<cr>
nn <silent>\ :BLines<cr>
nn <silent>\| :Lines<cr>
nn <silent><c-c> :Commands<cr>
nn <leader><bs> :FzfSwitchProject<cr>
nn K i<cr><esc>
nn <leader><leader> a<space><right><esc>
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
nn <silent><leader>tz :Goyo<cr>
nn <leader>tc :Codi!!<cr>
nn <leader>ty :Startify<cr>
nn <leader>r :%s///gc
nn <leader>v ggVG
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
nn <silent><leader>` :Ttoggle<cr><c-w>wa
nn <silent><leader><esc> :Ttoggle<cr><c-w>wa
tno <silent><leader>` <c-\><c-n>:Ttoggle<cr>
tno <silent><leader><esc> <c-\><c-n>:Ttoggle<cr>
tno <silent><a-esc> <esc>
nn <silent><leader>tt :FloatermNew --title=T<cr>
tno <silent><leader>tt <c-\><c-n>:FloatermKill<cr>
nn <leader><cr> :TREPLSendLine<cr>j
vn <leader><cr> :TREPLSendSelection<cr>
no <silent><c-_> :Commentary<cr>j
ino <silent><c-_> <esc>:Commentary<cr>ja
nn <silent><leader> :WhichKey '<space>'<cr>
no <leader>tsd "=strftime("%Y-%m-%d")<cr>P
no <leader>tst "=strftime("%H:%M:%S")<cr>P
no <leader>tsm "=strftime("%Y-%m-%d \/ %H:%M:%S")<cr>P

