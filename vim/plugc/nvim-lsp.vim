nn <silent> gd <cmd>lua vim.lsp.buf.definition()<cr>
nn <silent> gD <cmd>lua vim.lsp.buf.declaration()<cr>
nn <silent> gr <cmd>lua vim.lsp.buf.references()<cr>
nn <silent> gi <cmd>lua vim.lsp.buf.implementation()<cr>
nn <silent> gh <cmd>lua vim.lsp.buf.hover()<cr>
nn <silent> gs <cmd>lua vim.lsp.buf.signature_help()<cr>
nn <silent> gp <cmd>lua vim.lsp.diagnostic.goto_prev()<cr>
nn <silent> gn <cmd>lua vim.lsp.diagnostic.goto_next()<cr>

if has ('nvim-0.5')
  luafile $VC/lspconfig.lua
endif

