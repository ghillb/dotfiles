require("lualine").setup({
  sections = { lualine_b = { "" }, lualine_x = { "" }, lualine_y = { "" }, lualine_z = { "" } },
})
vim.cmd("au TermLeave * source $NVIM_CONFIG/lua/plugins/lualine.lua")
vim.opt.buflisted = false
vim.wo.spell = false
vim.wo.number = false
vim.wo.relativenumber = false
vim.api.nvim_buf_set_keymap(0, "", "<tab>", "<nop>", { noremap = true, silent = true })

DisableTelescopeMappings()
