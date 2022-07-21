local packer_opts = {
  "github/copilot.vim",
  disable = vim.env.NVIM_EMBEDDED == "true",
  config = function()
    vim.g.copilot_globally_enabled = true
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_filetypes = {
      ["TelescopePrompt"] = false,
      ["spectre_panel"] = false,
      ["prompt"] = false,
    }
    vim.api.nvim_set_keymap("i", "<s-cr>", 'copilot#Accept("")', { expr = true, silent = true })
    vim.api.nvim_set_keymap("n", "<a-c>", ":Copilot<cr>", {})

    vim.api.nvim_create_autocmd("TextChangedI", {
      callback = function()
        if vim.g.copilot_globally_enabled then
          if not vim.b.copilot_enabled then
            vim.cmd("Copilot enable")
            vim.b.copilot_enabled = true
          end
        else
          if vim.b.copilot_enabled == nil or vim.b.copilot_enabled then
            vim.cmd("Copilot disable")
            vim.b.copilot_enabled = false
          end
        end
      end,
    })
  end,
}
return packer_opts
