
return function()
  local ok, trouble = pcall(require, 'trouble')
  if not ok then
    return
  end

  local config = {
    use_diagnostic_signs = true,
    icons = false,
  }

  trouble.setup(config)
  
  -- Keybindings
  vim.keymap.set("n", "<leader>tt", "<cmd>TroubleToggle<cr>")
  vim.keymap.set("n", "<a-bs>", "<cmd>TroubleToggle document_diagnostics<cr>")
end
