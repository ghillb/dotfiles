local dap_ui_ok, dap_ui = pcall(require, "dapui")
local dap_vt_ok, dap_virtual_text = pcall(require, "nvim-dap-virtual-text")
if not dap_ui_ok and dap_vt_ok then
  return
end

dap_ui.setup()

-- nvim-dap-virtual-text setup
local config = {
  enabled = true,
  enabled_commands = true,
  highlight_changed_variables = true,
  highlight_new_as_changed = false,
  show_stop_reason = true,
  commented = false,
  -- experimental features:
  virt_text_pos = "eol",
  all_frames = false,
  virt_lines = false,
  virt_text_win_col = nil,
}

dap_virtual_text.setup(config)

-- keymaps
local map = vim.keymap.set

map('n', "<leader>dc", ':lua require"dap".continue()<cr>')
map('n', "<leader>dsv", ':lua require"dap".step_over()<cr>')
map('n', "<leader>dsi", ':lua require"dap".step_into()<cr>')
map('n', "<leader>dso", ':lua require"dap".step_out()<cr>')
map('n', "<leader>dtb", ':lua require"dap".toggle_breakpoint()<cr>')
map('n', "<leader>dro", ':lua require"dap".repl.open()<cr>')
map('n', "<leader>drr", ':lua require"dap".repl.run_last()<cr>')

map('n', "<leader>fdc", ':lua require"telescope".extensions.dap.commands{}<cr>')
map('n', "<leader>fdb", ':lua require"telescope".extensions.dap.list_breakpoints{}<cr>')
map('n', "<leader>fdv", ':lua require"telescope".extensions.dap.variables{}<cr>')
map('n', "<leader>fdf", ':lua require"telescope".extensions.dap.frames{}<cr>')
