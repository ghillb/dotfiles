" various
nn K xi<cr><esc>
no x "_x
no X "_X
no Y yg_
no vv V
no V vg_
nn Q @q
vn Q :norm @q<cr>
vm s <plug>VSurround
ino kj <esc>
ino jk <esc>
xn <silent> p p:let @+=@0<cr>:let @"=@0<cr>
xn <silent> P P:let @+=@0<cr>:let @"=@0<cr>
vn / y/\V<c-r>=escape(@",'/\')<cr><cr>N
nm cg* *N"ccgn
nn <a-g> :G<cr>
no <c-j> <c-e>
no <c-k> <c-y>
no <c-y> <c-b>
nn <c-l> :let @/=""<cr><c-l>
no <c-s> :w<cr>
ino <c-s> <c-o>:w<cr>
nn <c-q> :x<cr>
ino <c-q> <esc>:x<cr>
no <up> <nop>
no <down> <nop>
no <left> <nop>
no <right> <nop>

" commands
cm w!! w !sudo tee > /dev/null %
cm :G !git -C %:p:h commit -am "--wip--" && git -C %:p:h push

" terminal mappings
nn <a-s-r> :w<cr>:T cr %<cr>
ino <a-s-r> <esc>:w<cr>:T cr %<cr>
nn <a-r> :TREPLSendLine<cr>j
vn <a-r> :TREPLSendSelection<cr>
nn <silent><a-e> :call ToggleFern()<cr>
nn <silent><a-esc> :Ttoggle<cr><c-w>wa
nn <a-.> :Tnext<cr>
nn <a-,> :Tprevious<cr>
nn <silent><a-/> :call NewTerminalToggle()<cr>
tno <a-.> <c-\><c-n>:Tnext<cr>i
tno <a-,> <c-\><c-n>:Tprevious<cr>i
tno <silent><a-/> <c-\><c-n>:call NewTerminalToggle()<cr>
tno <silent><a-esc> <c-\><c-n>:Ttoggle<cr>
tno ` <esc>
tno <esc> <c-\><c-n>

" split mappings
nn <silent> <a-h> :call TmuxMove('h')<cr>
nn <silent> <a-j> :call TmuxMove('j')<cr>
nn <silent> <a-k> :call TmuxMove('k')<cr>
nn <silent> <a-l> :call TmuxMove('l')<cr>
map - <c-w>-
map = <c-w>+
map + <c-w>>
map _ <c-w><

" fzf mapping
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

" leader mappings 
let mapleader = " "
nn <silent> <leader> :<c-u>WhichKey '<space>'<cr>
nn <silent> <localleader> :<c-u>WhichKey  '\'<CR>
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

" localleader mappings
let localleader = "\\"
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

if has('nvim-0.5')
" nvim lsp
  nn <silent> gd <cmd>lua vim.lsp.buf.definition()<cr>
  nn <silent> gD <cmd>lua vim.lsp.buf.declaration()<cr>
  nn <silent> gr <cmd>lua vim.lsp.buf.references()<cr>
  nn <silent> gi <cmd>lua vim.lsp.buf.implementation()<cr>
  nn <silent> gh <cmd>lua vim.lsp.buf.hover()<cr>
  nn <silent> gs <cmd>lua vim.lsp.buf.signature_help()<cr>
  nn <silent> gp <cmd>lua vim.lsp.diagnostic.goto_prev()<cr>
  nn <silent> gn <cmd>lua vim.lsp.diagnostic.goto_next()<cr>
  nn <silent> gF <cmd>Format<cr>
  " nn <silent> gF <cmd>lua vim.lsp.buf.formatting()<cr>
  nn <silent> gR <cmd>TroubleToggle lsp_references<cr>

" nvim compe
  ino <silent><expr> <cr>      compe#confirm('<cr>')
  ino <silent><expr> <a-space> compe#complete()
  ino <silent><expr> <cr>      compe#confirm('<cr>')
  ino <silent><expr> <c-e>     compe#close('<c-e>')
  ino <silent><expr> <c-f>     compe#scroll({ 'delta': +4 })
  ino <silent><expr> <c-d>     compe#scroll({ 'delta': -4 })
  
" vsnip vim
  imap <expr> <c-e>   vsnip#expandable()  ? '<plug>(vsnip-expand)'         : '<c-e>'
  smap <expr> <c-e>   vsnip#expandable()  ? '<plug>(vsnip-expand)'         : '<c-e>'
  imap <expr> <c-l>   vsnip#available(1)  ? '<plug>(vsnip-expand-or-jump)' : '<c-l>'
  smap <expr> <c-l>   vsnip#available(1)  ? '<plug>(vsnip-expand-or-jump)' : '<c-l>'
  imap <expr> <tab>   vsnip#jumpable(1)   ? '<plug>(vsnip-jump-next)'      : '<tab>'
  smap <expr> <tab>   vsnip#jumpable(1)   ? '<plug>(vsnip-jump-next)'      : '<tab>'
  imap <expr> <s-tab> vsnip#jumpable(-1)  ? '<plug>(vsnip-jump-prev)'      : '<s-Tab>'
  smap <expr> <s-tab> vsnip#jumpable(-1)  ? '<plug>(vsnip-jump-prev)'      : '<s-Tab>'

" bufferline
  nn <silent><left> :BufferLineCyclePrev<cr>
  nn <silent><right> :BufferLineCycleNext<cr>
  nn <silent><a-left> :BufferLineMovePrev<cr>
  nn <silent><a-right> :BufferLineMoveNext<cr>
  nn <silent><a-q> :bdelete<cr>
  nn <silent>gb :BufferLinePick<cr>
  nn <silent>be :BufferLineSortByExtension<cr>
  nn <silent>bd :BufferLineSortByDirectory<cr>

endif

