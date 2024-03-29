vim.g.mapleader = " "
vim.g.localleader = "\\"

local map = vim.keymap.set

map("n", "<up>", "<nop>")
map("n", "<down>", "<nop>")
map("n", "<left>", "<nop>")
map("n", "<right>", "<nop>")
map("c", "<tab>", "<nop>")
map("c", "<s-tab>", "<nop>")
map("i", "<tab>", "v:lua.user.fn.tab_binding()", { expr = true })
map("i", "<s-tab>", "v:lua.user.fn.s_tab_binding()", { expr = true })
map({ "n", "v" }, "<c-i>", "<c-i>") -- separate <c-i> from <tab>, does not work in ms terminal
map({ "n", "v" }, "]b", "<esc><plug>(CybuLastusedNext)") -- ms term can not differentiate between <c-i> and <tab>
map({ "n", "v" }, "[b", "<esc><plug>(CybuLastusedPrev)")
map({ "n", "v", "i" }, "<a-tab>", "<nop>")
map({ "n", "v", "i" }, "<a-s-tab>", "<nop>")
map("i", "<c-tab>", "<nop>")
map("i", "<c-s-tab>", "<nop>")
map("n", "<s-space>", "<nop>")
map("n", "<c-s-space>", "<nop>")
map("n", "<esc>", function()
  vim.cmd("nohl")
end)

map({ "n", "v" }, "H", "^")
map({ "n", "v" }, "L", "g_")
map("n", "J", "mzJ`z")
map("n", "K", "i<cr><esc>")
map({ "n", "v" }, "gK", "K")
map({ "n", "v" }, "vv", "V")
map("n", "V", "vg_")
map("n", "Y", "yg_")
map("n", "dd", function()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    print("Empty line")
    return '"_dd'
  else
    return "dd"
  end
end, { expr = true })
map({ "n", "v" }, "x", '"_x')
map({ "n", "v" }, "X", '"_X')
map({ "n", "v" }, "j", "gj")
map({ "n", "v" }, "k", "gk")
map("i", "kj", "<esc>")
map("i", "jk", "<esc>")
map("v", "p", '"_c<c-r><c-o>+<esc>')
map("n", "gp", "viwp", { remap = true })
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "*", "*N")
map("n", "cg*", '*N"ccgn')
map("n", "c*", "*:%s//")
map("v", "<", "<gv")
map("v", ">", ">gv")
map("n", "Q", "@q")
map("n", "d[", ":diffget //2<cr>")
map("n", "d]", ":diffget //3<cr>")
map("n", "gf", user.fn.create_or_go_to_file, { silent = true })
map("x", "s", "<Plug>VSurround")

map("n", "<c-c>", "ciw", { remap = true })
map("n", "<c-j>", "<c-e>")
map("n", "<c-k>", "<c-y>")
map("n", "<c-y>", "<c-b>")
map("n", "<c-l>", ':let @/=""<cr>:e %<cr><c-l>')
map({ "n", "v", "i" }, "<c-s>", function()
  vim.cmd("w")
end)
map({ "n", "v", "i" }, "<c-q>", function()
  vim.cmd('execute "normal ZZ"')
end)
map("i", "<c-bs>", "<c-o>db<c-o>x", { remap = true })
map("i", "<c-F20>", "<c-bs>", { remap = true }) -- emulate on win term
map("i", "<c-w>", "<c-bs>", { remap = true })
map("i", "<c-l>", "<c-o>dl", { remap = true })
map("i", "<c-del>", "<c-o>de", { remap = true })
map("i", "<c-right>", "<c-\\><c-o>w")
map("i", "<c-left>", "<c-\\><c-o>b")

-- terminal control mappings
map("n", "<a-esc>", ":Ttoggle<cr><c-w>wa", { silent = true })
map("t", "<a-esc>", "<c-\\><c-n>:Ttoggle<cr>", { silent = true })
map("n", "<a-`>", "<a-esc>", { remap = true })
map("t", "<a-`>", "<a-esc>", { remap = true })
map("n", "<a-.>", ":Tnext<cr>", { silent = true })
map("n", "<a-,>", ":Tprevious<cr>", { silent = true })
map("t", "<a-.>", "<c-\\><c-n>:Tnext<cr>i")
map("t", "<a-,>", "<c-\\><c-n>:Tprevious<cr>i")
map({ "n", "t" }, "<a-/>", user.fn.new_terminal, { silent = true })
map("t", "`", "<esc>")
map("t", "<esc>", "<c-\\><c-n>")

-- command mode mappings
map("c", "w!!", "w !sudo tee > /dev/null %")
map("c", "GG", '!git -C %:p:h commit -am "--wip--" && git -C %:p:h -c push.default=current push')

-- buffer / window / tab mappings
map("n", "<a-h>", function()
  user.fn.tmux_switch_pane("h")
end, { silent = true })
map("n", "<a-j>", function()
  user.fn.tmux_switch_pane("j")
end, { silent = true })
map("n", "<a-k>", function()
  user.fn.tmux_switch_pane("k")
end, { silent = true })
map("n", "<a-l>", function()
  user.fn.tmux_switch_pane("l")
end, { silent = true })
map("n", "<a-e>", user.fn.drawer_toggle)
map("n", "<a-q>", user.fn.close_view)
map("n", "<a-->", "<c-w>-")
map("n", "<a-=>", "<c-w>+")
map("n", "<a-+>", "<c-w>>")
map("n", "<a-_>", "<c-w><")
map("n", "<a-g>", user.fn.toggle_fugitive)
map("n", "<a-o>", "<c-w>o<cr>")
map("n", "<c-w>O", ":%bd<cr><c-o>:bd#<cr>")
map("n", "<C-w>z", "<c-w>|<c-w>_")
map("n", "<c-w>tn", ":$tabnew<cr>:sleep 50m<cr>:Telescope find_files<cr>")
map("n", "<c-w>tq", ":tabclose<cr>")
map("n", "<c-w>to", ":tabonly<cr>")
map("n", "<left>", ":tabp<cr>")
map("n", "<right>", ":tabn<cr>")
map("n", "<up>", "<plug>(CybuPrev)")
map("n", "<down>", "<plug>(CybuNext)")
map("n", "<a-left>", ":-tabmove<cr>")
map("n", "<a-right>", ":+tabmove<cr>")

-- quickfix mappings
map("n", "[q", ":QFPrev<cr>")
map("n", "]q", ":QFNext<cr>")
map("n", "[l", ":LLPrev<cr>")
map("n", "]l", ":LLNext<cr>")

-- leader mappings
map("n", "<leader><leader>", "a<space><esc>")
map("n", "<leader>bn", ":bnext<cr>")
map("n", "<leader>bp", ":bprevious<cr>")
map("n", "<leader>bc", ":enew<cr>")
map("n", "<leader>bd", ":bd<cr>")
map("n", "<leader>bb", ":buffers<cr>")
map("n", "<leader>bo", ":w<bar>%bd<bar>e#<bar>bd#<cr>")
map("n", "<leader>tg", user.fn.toggle_gutter)
map("n", "<leader>tz", ":ZenMode<cr>", { silent = true })
map("n", "<leader>tw", ":Twilight<cr>", { silent = true })
map("n", "<leader>tr", ":Codi!!<cr>")
map("n", "<leader>tc", ":lua ToggleCopilot()<cr>", { silent = true })
map("n", "<leader>tl", ":Luapad<cr>")
map("n", "<leader>tdt", ":windo diffthis<cr>")
map("n", "<leader>tdo", ":windo diffoff<cr>")
map("n", "<leader>ti", ":IndentBlanklineToggle<cr>")
map("n", "<leader>ts", ":setlocal spell!<cr>")
map("n", "<leader>ty", ":Alpha<cr>")
map("n", "<leader>ta", ":AerialToggle<cr>")
map("n", "<leader>tu", ":UndotreeToggle<cr>")
map("n", "<leader>tp", ":set paste!<cr>")
map("n", "<leader>tm", ":Glow<cr>")
map("n", "<leader>tt", "<cmd>TroubleToggle<cr>")
map("n", "<leader>se", ":VsnipOpen<cr>")
map("v", "<leader>se", ":VsnipYank title <bar> VsnipOpenVsplit<cr>")
map("n", "<leader>sy", ":VsnipYank")
map("n", "<leader>ss", '<cmd>lua require("persistence").load()<cr>')
map("n", "<leader>sl", '<cmd>lua require("persistence").load({ last = true })<cr>')
map("n", "<leader>sq", '<cmd>lua require("persistence").stop()<cr>')
map("n", "<leader>zi", "<c-w>_<bar><c-w>\\|")
map("n", "<leader>zo", "<c-w>=")
map("n", "<leader>e", ":NnnPicker %:p:h<cr>", { silent = true })
map("n", "<leader>gg", ":G<cr>")
map("n", "<leader>gw", ":Gwrite<cr>")
map("n", "<leader>gr", ":G restore --source %<left><left><space>")
map("n", "<leader>gd", ":DiffviewOpen ")
map("v", "<leader>gd", '"0y:DiffviewOpen <c-r>0 ')
map("n", "<leader>gfh", ":DiffviewFileHistory<cr>")
map("n", "<leader>gmt", ":Gvdiffsplit!<cr>")
map("n", "<leader>gcc", ":G checkout %")
map("n", "<leader>gcb", ":G checkout -b")
map("n", "<leader>glo", ":GV<cr>")
map("n", "<leader>gll", ":GV!<cr>")
map("n", "<leader>gpl", ":G pull<cr>")
map("n", "<leader>gps", ":G -c push.default=current push<cr>")
map("n", "<leader>gfpl", ":G pull -f<cr>")
map("n", "<leader>gfps", ":G -c push.default=current push -f<cr>")
map("n", "<leader>gss", ":G stash<cr>")
map("n", "<leader>gsp", ":G stash pop -q<cr>")
map("n", "<leader>ga", ":G add -p<cr>")
map("n", "<leader>gb", ":Git blame<cr>")
map("n", "<leader>ia", ":Neogen<cr>")
map("n", "<leader>if", "i<c-r>=expand('%:t')<cr><esc>")
map("n", "<leader>ipa", "i<c-r>=expand('%:p')<cr><esc>")
map("n", "<leader>ipr", "i<c-r>=expand('%')<cr><esc>")
map("n", "<leader>itd", '"=strftime("%Y-%m-%d")<cr>P')
map("n", "<leader>itt", '"=strftime("%H:%M:%S")<cr>P')
map("n", "<leader>itm", '"=strftime("%Y-%m-%d \\/ %H:%M:%S")<cr>P')
map("n", "<leader>ypd", "yap<S-}>p")
map("n", "<leader>ypu", "yap<S-{>p")
map("n", "<leader>p", "o<esc>p")
map("n", "<leader>P", "O<esc>P")
map("n", "<leader>o", "o<esc>")
map("n", "<leader>O", "O<esc>")

-- localleader mappings
map("n", "<localleader><cr>", ":lua user.fn.set_root('git_worktree', true)<cr>", { silent = true })
map("n", "<localleader><bs>", ":lua user.fn.set_root('parent_dir', true)<cr>", { silent = true })
map("n", "<localleader>/", ":lua user.fn.set_root('file_dir', true)<cr>", { silent = true })
map("n", "<localleader>\\", ":lua user.fn.set_root('origin', true)<cr>", { silent = true })
map("n", "<localleader>sr", ":%s///gc<left><left><left><left>")
map("n", "<localleader>sq", ":vim// %<left><left><left>")
map("n", "<localleader>sl", ":lv// %<left><left><left>")
map("n", "<localleader>q", "<cmd>QFToggle!<cr>", { silent = true })
map("n", "<localleader>l", "<cmd>LLToggle!<cr>", { silent = true })
map("n", "<localleader>dw", ":%s/\\s\\+$//e<cr>")
map("n", "<localleader>ve", ":e $MYVIMRC<cr>")
map("n", "<localleader>vr", ":source $MYVIMRC<cr>")
map("n", "<localleader>vs", ":source %<cr>")
map("n", "<localleader>vt", ":AsyncTask nvim-plugin-tests<cr>")
map("n", "<localleader>pc", function()
  return require("packer").compile()
end)
map("n", "<localleader>pu", function()
  return require("packer").sync()
end)

-- lsp mappings
map("n", "gd", "<cmd>Telescope lsp_definitions<cr>")
map("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>")
map("n", "gr", function()
  require("telescope.builtin").lsp_references({ include_declaration = false, include_current_line = false })
end, {})
map("n", "gi", "<cmd>Telescope lsp_implementations<cr>")
map("n", "gD", vim.lsp.buf.declaration)
map("n", "gh", vim.lsp.buf.hover)
map("n", "gs", vim.lsp.buf.signature_help)
map("n", "g*", vim.lsp.buf.rename)
map("n", "]d", vim.diagnostic.goto_next)
map("n", "[d", vim.diagnostic.goto_prev)
map({ "n", "v" }, "gF", vim.lsp.buf.format)
map("n", "<a-space>", vim.diagnostic.open_float)
map("n", "<a-bs>", "<cmd>TroubleToggle document_diagnostics<cr>")
map({ "n", "v" }, "<a-cr>", vim.lsp.buf.code_action)

-- pseudo text objects
map("x", "il", "g_o^")
map("o", "il", ":<c-u>normal vil<cr>")
map("x", "al", "$o0")
map("o", "al", ":<c-u>normal val<cr>")

map("x", "i%", "ggoGV")
map("o", "i%", ":<c-u>normal vi%<cr>")
