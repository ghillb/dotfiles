local packer_opts = {
  "github/copilot.vim",
  disable = vim.env.NVIM_EMBEDDED == "true",
  config = function()
    local copilot_enabled = true
    user.indicators.copilot = "C"
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_filetypes = {
      ["TelescopePrompt"] = false,
      ["spectre_panel"] = false,
      ["prompt"] = false,
      ["dap-repl"] = false,
    }
    vim.api.nvim_set_keymap("i", "<s-cr>", 'copilot#Accept("")', { expr = true, silent = true })
    vim.api.nvim_set_keymap("n", "<a-c>", ":Copilot<cr>", {})

    function _G.ToggleCopilot()
      if copilot_enabled then
        vim.api.nvim_command("Copilot disable")
        user.indicators.copilot = "Ȼ"
      else
        vim.api.nvim_command("Copilot enable")
        user.indicators.copilot = "C"
      end
      copilot_enabled = not copilot_enabled
      vim.api.nvim_command("Copilot status")
    end
  end,
}
return packer_opts
