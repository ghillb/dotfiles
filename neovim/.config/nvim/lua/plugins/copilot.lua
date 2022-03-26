local packer_opts = {
  "github/copilot.vim",
  config = function()
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.api.nvim_set_keymap("i", "<a-space>", 'copilot#Accept("")', { expr = true, silent = true })
  end,
}
return packer_opts
