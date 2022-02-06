vim.api.nvim_buf_set_keymap(0, "", "dd", ":.Reject<cr>", { noremap = true, silent = true })
vim.api.nvim_buf_set_keymap(0, "", "<localleader>r", ":cdo s///", { noremap = true, silent = false })
DisableTelescopeMappings()
