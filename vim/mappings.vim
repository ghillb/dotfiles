let mapleader = " "
let localleader = "\\"
nn K a<cr><esc>
no x "_x
no X "_X
no Y yg_
no vv V
no V vg_
cm w!! w !sudo tee > /dev/null %
cm :g !git -C %:p:h commit -am "--wip--" && git -C %:p:h push
xn <silent> p p:let @+=@0<CR>:let @"=@0<CR>
xn <silent> P P:let @+=@0<CR>:let @"=@0<CR>
ino kj <esc>
ino jk <esc>
no <c-j> <c-e>
no <c-k> <c-y>
no <c-y> <c-b>
im <c-w> <c-o><c-w>
nn <c-l> :let @/=""<cr><c-l>
no <c-s> :w<cr>
ino <c-s> <esc>:w<cr>
nn <c-q> :x<cr>
ino <c-q> <esc>:x<cr>
no <localleader>/ :chdir %:p:h<cr>
nn <localleader>r :%s///gc
no <localleader>w :%s/\s\+$//e<cr>
nn <localleader>, :e $MYVIMRC<cr>
nn <localleader>. :so $MYVIMRC<cr>
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
ino <a-cr> <c-x><c-p>
nn <a-s-r> :w<cr>:!cr %<cr>
ino <a-s-r> <esc>:w<cr>:!cr %<cr>
nn <a-r> :TREPLSendLine<cr>j
vn <a-r> :TREPLSendSelection<cr>
nn <silent> <a-h> :call TmuxMove('h')<cr>
nn <silent> <a-j> :call TmuxMove('j')<cr>
nn <silent> <a-k> :call TmuxMove('k')<cr>
nn <silent> <a-l> :call TmuxMove('l')<cr>
map - <c-w>-
map = <c-w>+
no <up> <nop>
no <down> <nop>
no <left> <nop>
no <right> <nop>
no <silent><c-_> :Commentary<cr>j
ino <silent><c-_> <esc>:Commentary<cr>ja
nn <silent><c-p> :Rg<cr>
nn <silent><c-e> :call FzfOmniFiles()<cr>
nn <silent><c-a-e> :Files<cr>
nn <silent><c-b> :Buffers<cr>
nn <silent><a-\> :BLines<cr>
nn <silent><c-\> :Lines<cr>
nn <silent><c-c> :Commands<cr>
nn <silent><c-g> :GBranches<cr>
nn <leader><bs> :FzfSwitchProject<cr>
vn / y/\V<c-r>=escape(@",'/\')<cr><cr>N
nn <leader>/ viwy/\V<c-r>=escape(@",'/\')<cr><cr>N
nn <leader><leader> a<space><esc>
no <leader>p o<esc>p
no <leader>P O<esc>p
nn <leader>o o<esc>
nn <leader>O O<esc>
nm <leader>s ys
vm <leader>s <plug>VSurround
nn <leader>bn :bnext<cr>
nn <leader>bp :bprevious<cr>
nn <leader>bc :enew<cr>
nn <leader>bd :bd<cr>
nn <leader>bl :buffers<cr>
nn <leader>bo :w<bar>%bd<bar>e#<bar>bd#<cr>
nn <leader>to :tabo<cr>
nn <silent><leader>tg :set rnu! \| :set nu! \| :GitGutterToggle<cr>
nn <silent><leader>tz :Goyo<cr>
nn <leader>tl :Limelight!!<cr>
nn <leader>tc :Codi!!<cr>
nn <leader>ty :Startify<cr>
nn <leader>ti :IndentLinesToggle<cr>
nn <leader>tu :UndotreeToggle<cr>
nn <leader>v ggVG
nn <leader>gs :G<cr>
nn <leader>gd :Gvdiffsplit<cr>
nn <leader>gc :G checkout %
nn <leader>glo :GV<cr>
nn <leader>gll :GV!<cr>
nn <leader>gpl :G pull<cr>
nn <leader>gps :G push<cr>
nn <leader>ga :G add -p<cr>
nn <leader>gb :Gblame<cr>
no <leader>id i<c-r>=expand('%:p:h').'/'<cr><esc>
no <leader>itd "=strftime("%Y-%m-%d")<cr>P
no <leader>itt "=strftime("%H:%M:%S")<cr>P
no <leader>itm "=strftime("%Y-%m-%d \/ %H:%M:%S")<cr>P
nn <silent><leader> :WhichKey '<space>'<cr>
nn <silent><a-1> :call ToggleFern()<cr>
nn <silent><a-t> :Ttoggle<cr><c-w>wa
nn <silent><a-g> :G<cr>
tno <silent><a-t> <c-\><c-n>:Ttoggle<cr>
tno <c-w> <c-\><c-n><c-w>
tno <esc> <c-\><c-n>
tno kj <esc>
tno jk <esc>
tno <localleader><esc> <esc>

