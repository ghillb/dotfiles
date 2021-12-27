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
local nnoremap = vim.keymap.nnoremap
nnoremap({ "<leader>dc", ':lua require"dap".continue()<cr>' })
nnoremap({ "<leader>dsv", ':lua require"dap".step_over()<cr>' })
nnoremap({ "<leader>dsi", ':lua require"dap".step_into()<cr>' })
nnoremap({ "<leader>dso", ':lua require"dap".step_out()<cr>' })
nnoremap({ "<leader>dtb", ':lua require"dap".toggle_breakpoint()<cr>' })
nnoremap({ "<leader>dro", ':lua require"dap".repl.open()<cr>' })
nnoremap({ "<leader>drr", ':lua require"dap".repl.run_last()<cr>' })

nnoremap({ "<leader>fdc", ':lua require"telescope".extensions.dap.commands{}<cr>' })
nnoremap({ "<leader>fdb", ':lua require"telescope".extensions.dap.list_breakpoints{}<cr>' })
nnoremap({ "<leader>fdv", ':lua require"telescope".extensions.dap.variables{}<cr>' })
nnoremap({ "<leader>fdf", ':lua require"telescope".extensions.dap.frames{}<cr>' })
