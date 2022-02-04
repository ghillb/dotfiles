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

local map = vim.keymap.set

map("n", "<F1>", ":lua require('dap').continue()<cr>")
map("n", "<F2>", ":lua require('dap').step_over()<cr>")
map("n", "<F3>", ":lua require('dap').step_into()<cr>")
map("n", "<F4>", ":lua require('dap').step_out()<cr>")
map("n", "<F5>", ":lua require('dap').toggle_breakpoint()<cr>")
map("n", "<F10>", ":lua require('dapui').toggle()<cr>")

map("n", "<Leader>dsc", ":lua require('dap').continue()<cr>")
map("n", "<Leader>dsv", ":lua require('dap').step_over()<cr>")
map("n", "<Leader>dsi", ":lua require('dap').step_into()<cr>")
map("n", "<Leader>dso", ":lua require('dap').step_out()<cr>")

map("n", "<Leader>dhh", ":lua require('dap.ui.variables').hover()<cr>")
map("v", "<Leader>dhv", ":lua require('dap.ui.variables').visual_hover()<cr>")

map("n", "<Leader>duh", ":lua require('dap.ui.widgets').hover()<cr>")
map("n", "<Leader>duf", ":lua local widgets=require('dap.ui.widgets');widgets.centered_float(widgets.scopes)<cr>")

map("n", "<Leader>dro", ":lua require('dap').repl.open()<cr>")
map("n", "<Leader>drl", ":lua require('dap').repl.run_last()<cr>")

map("n", "<Leader>dbc", ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>")
map("n", "<Leader>dbm", ":lua require('dap').set_breakpoint({ nil, nil, vim.fn.input('Log point message: ')})<cr>")
map("n", "<Leader>dbt", ":lua require('dap').toggle_breakpoint()<cr>")

map("n", "<Leader>dc", ":lua require('dap.ui.variables').scopes()<cr>")
map("n", "<Leader>di", ":lua require('dapui').toggle()<cr>")

map("n", "<leader>fdc", ':lua require"telescope".extensions.dap.commands{}<cr>')
map("n", "<leader>fdb", ':lua require"telescope".extensions.dap.list_breakpoints{}<cr>')
map("n", "<leader>fdv", ':lua require"telescope".extensions.dap.variables{}<cr>')
map("n", "<leader>fdf", ':lua require"telescope".extensions.dap.frames{}<cr>')
