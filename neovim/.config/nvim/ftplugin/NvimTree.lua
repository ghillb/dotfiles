	vim.api.nvim_buf_set_keymap(0, "", "<a-esc>", "<c-w>l", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(0, "", "<a-q>", ":NvimTreeClose<cr>", { noremap = true, silent = true })
	DisableTelescopeMappings()

