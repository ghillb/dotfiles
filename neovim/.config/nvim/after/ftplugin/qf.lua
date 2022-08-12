vim.api.nvim_buf_set_keymap(0, "", "dd", ":.Reject<cr>", { noremap = true, silent = true })
vim.api.nvim_buf_set_keymap(0, "", "<localleader>sr", ":cdo s///", { noremap = true, silent = false })
vim.api.nvim_buf_set_keymap(0, "n", "o", "<cr><c-w>p", { noremap = true, silent = true })
user.fn.disable_telescope_mappings()
