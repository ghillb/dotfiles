local packer_opts = {
  "Jorengarenar/vim-MvVis",
  config = function()
    vim.g.MvVis_mappings = 0

    vim.api.nvim_set_keymap("v", "<left>", "<plug>(MvVisLeft)", {})
    vim.api.nvim_set_keymap("v", "<down>", "<plug>(MvVisDown)", {})
    vim.api.nvim_set_keymap("v", "<up>", "<plug>(MvVisUp)", {})
    vim.api.nvim_set_keymap("v", "<right>", "<plug>(MvVisRight)", {})
  end,
}
return packer_opts
