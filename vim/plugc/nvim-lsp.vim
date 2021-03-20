nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gh <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gs <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gp <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> gn <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

if has ('nvim-0.5')
  luafile $VC/lspconfig.lua
endif

