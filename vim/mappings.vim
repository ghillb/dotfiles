" various
no x "_x
no X "_X
no Y yg_
no vv V
nn j gj
nn k gk
no n nzzzv
no N Nzzzv
nn H ^
vn H ^
nn L $
vn L $h
no J mzJ`z
nn K xi<cr><esc>
no V vg_
nn Q @q
vn Q :norm @q<cr>
vm s <plug>VSurround
no <silent><c-_> :lua require('Comment').toggle()<cr>j
ino kj <esc>
ino jk <esc>
xn <silent> p p:let @+=@0<cr>:let @"=@0<cr>
xn <silent> P P:let @+=@0<cr>:let @"=@0<cr>
vn / y/\V<c-r>=escape(@",'/\')<cr><cr>N
nm cg* *N"ccgn
nn cn *``cgn
nn cN *``cgN
nn d[ :diffget //2<cr>
nn d] :diffget //3<cr>
nn <silent>gf :lua CreateOrGoToFile()<cr>
no <c-d> <c-d>zz
no <c-u> <c-u>zz
no <c-j> <c-e>
no <c-k> <c-y>
no <c-y> <c-b>
nn <c-l> :let @/=""<cr>:NvimTreeRefresh<cr><c-l>
map <c-w>O :%bd<cr><c-o>:bd#<cr>
no <c-s> :w<cr>
ino <c-s> <c-o>:w<cr>
nn <c-q> :x<cr>
ino <c-q> <esc>:x<cr>
ino <c-h> <c-w>
ino <c-l> <c-o>de
ino <c-del> <c-o>de
no <up> <nop>
no <down> <nop>
no <left> <nop>
no <right> <nop>

" commands
cm w!! w !sudo tee > /dev/null %
cm GG !git -C %:p:h commit -am "--wip--" && git -C %:p:h -c push.default=current push

" terminal mappings
nn <a-s-r> :AsyncTask file-run<cr>
ino <a-s-r> <esc>:AsyncTask file-run<cr>
nn <a-r> :TREPLSendLine<cr>j
vn <a-r> :TREPLSendSelection<cr>
nn <silent><a-esc> :Ttoggle<cr><c-w>wa
nn <a-.> :Tnext<cr>
nn <a-,> :Tprevious<cr>
nn <silent><a-/> :lua NewTerminal()<cr>
tno <a-.> <c-\><c-n>:Tnext<cr>i
tno <a-,> <c-\><c-n>:Tprevious<cr>i
tno <silent><a-/> <c-\><c-n>:lua NewTerminal()<cr>
tno <silent><a-esc> <c-\><c-n>:Ttoggle<cr>
tno ` <esc>
tno <esc> <c-\><c-n>

" window / buffer / split mappings
nn <silent> <a-h> :lua TmuxSwitchPane('h')<cr>
nn <silent> <a-j> :lua TmuxSwitchPane('j')<cr>
nn <silent> <a-k> :lua TmuxSwitchPane('k')<cr>
nn <silent> <a-l> :lua TmuxSwitchPane('l')<cr>
map <a--> <c-w>-
map <a-=> <c-w>+
map <a-+> <c-w>>
map <a-_> <c-w><
nn <a-g> :G<cr>
nn <silent><a-q> :lua CloseView()<cr>

" quickfix
nnoremap [q <cmd>QFPrev<CR>
nnoremap ]q <cmd>QFNext<CR>
nnoremap [l <cmd>LLPrev<CR>
nnoremap ]l <cmd>LLNext<CR>

" leader mappings
let mapleader = " "
nn <leader><leader> a<space><esc>
nn <leader>bn :bnext<cr>
nn <leader>bp :bprevious<cr>
nn <leader>bc :enew<cr>
nn <leader>bd :bd<cr>
nn <leader>bl :buffers<cr>
nn <leader>bo :w<bar>%bd<bar>e#<bar>bd#<cr>
nn <leader>to :tabo<cr>
nn <silent><leader>tg :lua ToggleGutter()<cr>
nn <silent><leader>tz :ZenMode<cr>
nn <silent><leader>tw :Twilight<cr>
nn <leader>tc :Codi!!<cr>
nn <leader>td :diffthis<cr>
nn <leader>ts :setlocal spell!<cr>
nn <leader>ty :Startify<cr>
nn <leader>ti :IndentBlanklineToggle<cr>
nn <leader>tu :UndotreeToggle<cr>
nn <leader>tp :set paste!<cr>
no <leader>tm :Glow<cr><c-w>\| <c-w>_
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
nn <leader>ve :e $VC/init.vim<$MYVIMRCcr>
nn <leader>vr :so $MYVIMRC<cr>
nn <silent> <leader>e :NnnPicker %:p:h<cr>
nn <leader>gg :G<cr>
nn <leader>gr :G restore --source %
nn <leader>gd :DiffviewOpen 
nn <leader>gf :DiffviewFileHistory<cr>
nn <leader>gmt :Gvdiffsplit!<cr>
nn <leader>gw :Gwrite<cr>
nn <leader>gcc :G checkout %
nn <leader>gcb :G checkout -b 
nn <leader>glo :GV<cr>
nn <leader>gll :GV!<cr>
nn <leader>gpl :G -c pull.default=current pull<cr>
no <leader>gps :G -c push.default=current push<cr>
nn <leader>gss :G stash<cr>
nn <leader>gsp :G stash pop -q<cr>
nn <leader>ga :G add -p<cr>
nn <leader>gb :Git blame<cr>
no <leader>id i<c-r>=expand('%:p:h').'/'<cr><esc>
no <leader>itd "=strftime("%Y-%m-%d")<cr>P
no <leader>itt "=strftime("%H:%M:%S")<cr>P
no <leader>itm "=strftime("%Y-%m-%d \/ %H:%M:%S")<cr>P
no <leader>cpd yap<S-}>p
no <leader>cpu yap<S-{>p

" localleader mappings
let localleader = "\\"
no <silent><localleader><cr> :lua SetRoot('git_worktree')<cr>
no <silent><localleader><bs> :lua SetRoot('parent_dir')<cr>
no <silent><localleader>/ :lua SetRoot('current_dir')<cr>
no <silent><localleader>\ :chdir $VIM_ROOT<cr> \| :echo "back to root -> " . $VIM_ROOT<cr>
nn <localleader>sr :%s///gc<left><left><left><left>
nn <localleader>sq :vim// **/*<left><left><left><left><left><left>
nn <localleader>sl :lv// %<left><left><left>
nn <silent> <localleader>q <cmd>QFToggle!<CR>
nn <silent> <localleader>l <cmd>LLToggle!<CR>
no <localleader>dw :%s/\s\+$//e<cr>
no <localleader>p o<esc>p
no <localleader>P O<esc>p
nn <localleader>o o<esc>
nn <localleader>O O<esc>
nn <localleader>v ggVG

" nvim lsp
nn <silent> gd <cmd>lua vim.lsp.buf.definition()<cr>
nn <silent> gD <cmd>lua vim.lsp.buf.declaration()<cr>
nn <silent> gr <cmd>lua vim.lsp.buf.references()<cr>
nn <silent> gi <cmd>lua vim.lsp.buf.implementation()<cr>
nn <silent> gh <cmd>lua vim.lsp.buf.hover()<cr>
nn <silent> gs <cmd>lua vim.lsp.buf.signature_help()<cr>
nn <silent> ]g :lua vim.lsp.diagnostic.goto_next({ popup_opts = { border = "single" }})<cr>
nn <silent> [g :lua vim.lsp.diagnostic.goto_prev({ popup_opts = { border = "single" }})<cr>
nn <silent> <a-space> :lua vim.lsp.diagnostic.show_line_diagnostics({ border = "single" })<cr>
nn <silent> <a-\> <cmd>lua vim.lsp.buf.code_action()<cr>
nn <silent> gF <cmd>Format<cr>
" nn <silent> gF <cmd>lua vim.lsp.buf.formatting()<cr>
nn <silent> gR <cmd>TroubleToggle lsp_references<cr>

"nvim telescope
nn <c-e> <cmd>lua TelescopeOmniFiles()<cr>
nn <c-a-e> <cmd>Telescope find_files<cr>
nn <c-p> <cmd>Telescope live_grep<cr>
nn <c-b> <cmd>Telescope buffers<cr>
nn <c-\> <cmd>Telescope current_buffer_fuzzy_find<cr>
nn <c-g> :lua SwitchGitBranch()<cr>
nn <esc><esc> <cmd>Telescope project display_type=full<cr>
nn <leader>fg <cmd>Telescope git_status<cr>
nn <leader>fk <cmd>Telescope keymaps<cr>
nn <leader>fc <cmd>Telescope commands<cr>
nn <leader>fh <cmd>Telescope help_tags<cr>
nn <leader>fq <cmd>Telescope quickfix<cr>
nn <leader>fl <cmd>Telescope localist<cr>
nn <leader>ft <cmd>lua require('telescope').extensions.asynctasks.all()<cr>

" vsnip vim
imap <expr> <c-e>   vsnip#expandable()  ? '<plug>(vsnip-expand)'         : '<c-e>'
smap <expr> <c-e>   vsnip#expandable()  ? '<plug>(vsnip-expand)'         : '<c-e>'
imap <expr> <tab>   vsnip#jumpable(1)   ? '<plug>(vsnip-jump-next)'      : '<tab>'
smap <expr> <tab>   vsnip#jumpable(1)   ? '<plug>(vsnip-jump-next)'      : '<tab>'
imap <expr> <s-tab> vsnip#jumpable(-1)  ? '<plug>(vsnip-jump-prev)'      : '<s-Tab>'
smap <expr> <s-tab> vsnip#jumpable(-1)  ? '<plug>(vsnip-jump-prev)'      : '<s-Tab>'

" bufferline
nn <silent><left> :BufferLineCyclePrev<cr>
nn <silent><right> :BufferLineCycleNext<cr>
nn <silent><a-left> :BufferLineMovePrev<cr>
nn <silent><a-right> :BufferLineMoveNext<cr>
nn <silent>gbp :BufferLinePick<cr>
nn <silent>gbe :BufferLineSortByExtension<cr>
nn <silent>gbd :BufferLineSortByDirectory<cr>

" diffview & nvimtree drawer toggle
nn <silent><a-e> :lua DrawerToggle()<cr>

