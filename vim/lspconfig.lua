-- general settings
vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	update_in_insert = false,
	float = { show_header = false, border = "single", source = "always" },
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "single",
})

vim.lsp.handlers["textDocument/signtureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = "single",
})

DiagnosticSigns = { Error = " ", Warn = " ", Hint = " ", Info = " " }

for type, icon in pairs(DiagnosticSigns) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.fn.sign_define('LightBulbSign', { text = "", texthl = "", linehl="", numhl="" })
vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
