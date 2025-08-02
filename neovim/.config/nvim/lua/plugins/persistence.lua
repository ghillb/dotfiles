
return function()
  local ok, persistence = pcall(require, "persistence")
  if not ok then
    return
  end

  persistence.setup()
  
  -- Keybindings
  vim.keymap.set("n", "<leader>ss", '<cmd>lua require("persistence").load()<cr>')
  vim.keymap.set("n", "<leader>sl", '<cmd>lua require("persistence").load({ last = true })<cr>')
  vim.keymap.set("n", "<leader>sq", '<cmd>lua require("persistence").stop()<cr>')
end