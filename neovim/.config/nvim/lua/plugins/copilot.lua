local packer_opts = {
  "github/copilot.vim",
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
      ["vimwiki"] = false,
    }

    vim.keymap.set("i", "<s-cr>", function()
      return vim.fn["copilot#Accept"]("<cr>")
    end, { expr = true, silent = true, replace_keycodes = false })
    vim.keymap.set("n", "<a-c>", function()
      vim.cmd("Copilot")
    end, {})

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
