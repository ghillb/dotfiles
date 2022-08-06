local packer_opts = {
  "github/copilot.vim",
  disable = vim.env.NVIM_EMBEDDED == "true",
  config = function()
    _G.copilot_enabled, _G.Indicators.copilot = true, "C"
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
      if _G.copilot_enabled then
        vim.api.nvim_command("Copilot disable")
        _G.Indicators.copilot = "Ȼ"
      else
        vim.api.nvim_command("Copilot enable")
        _G.Indicators.copilot = "C"
      end
      _G.copilot_enabled = not _G.copilot_enabled
      vim.api.nvim_command("Copilot status")
    end
  end,
}
return packer_opts
