let mapleader = " "
let localleader = "\\"
nn K a<cr><esc>
no x "_x
no X "_X
no Y yg_
no vv V
no V vg_
nn Q @q
vn Q :norm @q<cr>
vm s <plug>VSurround
cm w!! w !sudo tee > /dev/null %
cm :G !git -C %:p:h commit -am "--wip--" && git -C %:p:h push
xn <silent> p p:let @+=@0<cr>:let @"=@0<cr>
xn <silent> P P:let @+=@0<cr>:let @"=@0<cr>
vn / y/\V<c-r>=escape(@",'/\')<cr><cr>N
nm cg* *N"ccgn
ino kj <esc>
ino jk <esc>
no <c-j> <c-e>
no <c-k> <c-y>
no <c-y> <c-b>
nn <c-l> :let @/=""<cr><c-l>
no <c-s> :w<cr>
ino <c-s> <c-o>:w<cr>
nn <c-q> :x<cr>
ino <c-q> <esc>:x<cr>
no <localleader><cr> :call SetRoot('git_root')<cr>
no <localleader><bs> :call SetRoot('parent_dir')<cr>
no <localleader>/ :call SetRoot('current_dir')<cr>
no <localleader>\ :chdir $VIM_ROOT<cr> \| :echo "back to root: " . $VIM_ROOT<cr>
nn <localleader>r :%s///gc<left><left><left><left>
nn <localleader>q :vim// **/*<left><left><left><left><left><left>
nn <localleader>l :lv// %<left><left><left>
no <localleader>w :%s/\s\+$//e<cr>
nn <localleader>, :e $MYVIMRC<cr>
nn <localleader>. :so $MYVIMRC<cr>
nn <silent><tab> :bnext<cr>
nn <silent><s-tab> :bprevious<cr>
ino <a-cr> <c-x><c-p>
nn <a-s-r> :w<cr>:T cr %<cr>
ino <a-s-r> <esc>:w<cr>:T cr %<cr>
nn <a-r> :TREPLSendLine<cr>j
vn <a-r> :TREPLSendSelection<cr>
nn <silent><a-1> :call ToggleFern()<cr>
nn <silent><a-esc> :Ttoggle<cr><c-w>wa
tno <silent><a-esc> <c-\><c-n>:Ttoggle<cr>
tno ` <c-\><c-n>
tno <a-`> <c-\><c-n><c-w>k
nn <silent> <a-h> :call TmuxMove('h')<cr>
nn <silent> <a-j> :call TmuxMove('j')<cr>
nn <silent> <a-k> :call TmuxMove('k')<cr>
nn <silent> <a-l> :call TmuxMove('l')<cr>
map - <c-w>-
map = <c-w>+
map + <c-w>>
map _ <c-w><
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
nn <silent><c-\> :BLines<cr>
nn <silent><a-\> :Lines<cr>
nn <silent><c-c> :Commands<cr>
nn <silent><c-g> :call OpenFzfCheckout()<cr>
nn <esc><esc> :FzfSwitchProject<cr>
nn <leader><leader> a<space><esc>
no <leader>p o<esc>p
no <leader>P O<esc>p
nn <leader>o o<esc>
nn <leader>O O<esc>
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
nn <leader>tp :set paste!<cr>
nn <leader>ttx <cmd>TroubleToggle<cr>
nn <leader>ttw <cmd>TroubleToggle lsp_workspace_diagnostics<cr>
nn <leader>ttd <cmd>TroubleToggle lsp_document_diagnostics<cr>
nn <leader>ttq <cmd>TroubleToggle quickfix<cr>
nn <leader>ttl <cmd>TroubleToggle loclist<cr>
nn <leader>ttt <cmd>TodoTrouble<cr>
nn <leader>se :VsnipOpen<cr>
vn <leader>se :VsnipYank vs_ <bar> VsnipOpenVsplit
vn <leader>sy :VsnipYank 
nn <leader>zi <c-w>_<bar><c-w>\|
nn <leader>zo <c-w>=
nn <leader>v ggVG
nn <leader>gg :G<cr>
nn <leader>gd :Gvdiffsplit<cr>
nn <leader>gc :G checkout %
nn <leader>glo :GV<cr>
nn <leader>gll :GV!<cr>
nn <leader>gpl :G -c pull.default=current pull<cr>
no <leader>gps :G -c push.default=current push<cr>
nn <leader>gss :G stash<cr>
nn <leader>gsp :G stash pop -q<cr>
nn <leader>ga :G add -p<cr>
nn <leader>gb :Gblame<cr>
no <leader>id i<c-r>=expand('%:p:h').'/'<cr><esc>
no <leader>itd "=strftime("%Y-%m-%d")<cr>P
no <leader>itt "=strftime("%H:%M:%S")<cr>P
no <leader>itm "=strftime("%Y-%m-%d \/ %H:%M:%S")<cr>P
no <leader>cp yap<S-}>p
nn <silent><leader> :WhichKey '<space>'<cr>

