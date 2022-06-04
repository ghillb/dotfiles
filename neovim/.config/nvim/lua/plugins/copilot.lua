local packer_opts = {
  "github/copilot.vim",
  config = function()
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_filetypes = {
      ["TelescopePrompt"] = false,
      ["spectre_panel"] = false,
      ["prompt"] = false,
    }
    vim.api.nvim_set_keymap("i", "<s-cr>", 'copilot#Accept("")', { expr = true, silent = true })
    vim.api.nvim_set_keymap("n", "<a-c>", ":Copilot<cr>", {})
  end,
}
return packer_opts
