local packer_opts = {
  "mfussenegger/nvim-dap",
  requires = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
  },
  config = function()
    local ok, dap_ui = pcall(require, "dapui")
    if not ok then
      return
    end

    -- nvim-dap-ui setup
    local config_dap_ui = {
      tray = {
        elements = { "repl" },
        size = 10,
        position = "bottom",
      },
    }
    dap_ui.setup(config_dap_ui)

    local dap_virtual_text = require("nvim-dap-virtual-text")

    -- nvim-dap-virtual-text setup
    local config_dap_vt = {
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      virt_text_pos = "eol",
    }

    dap_virtual_text.setup(config_dap_vt)

    local map = vim.keymap.set

    map("n", "<F1>", ":lua require('dap').continue()<cr>")
    map("n", "<F2>", ":lua require('dap').step_over()<cr>")
    map("n", "<F3>", ":lua require('dap').step_into()<cr>")
    map("n", "<F4>", ":lua require('dap').step_out()<cr>")
    map("n", "<F5>", ":lua require('dap').toggle_breakpoint()<cr>")
    map("n", "<F10>", ":lua require('dapui').toggle()<cr>")

    map("n", "<leader>dbc", ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>")
    map("n", "<leader>dbm", ":lua require('dap').set_breakpoint({ nil, nil, vim.fn.input('Log point message: ')})<cr>")

    map("n", "<leader>dsc", ":lua require('dap').continue()<cr>")
    map("n", "<leader>dsv", ":lua require('dap').step_over()<cr>")
    map("n", "<leader>dsi", ":lua require('dap').step_into()<cr>")
    map("n", "<leader>dso", ":lua require('dap').step_out()<cr>")

    map("n", "<leader>dtr", ":lua require('dap').repl.open()<cr>")
    map("n", "<leader>dtu", ":lua require('dapui').toggle()<cr>")
    map("n", "<leader>dtv", ":lua local widgets=require('dap.ui.widgets');widgets.centered_float(widgets.scopes)<cr>")

    map("n", "<leader>fdc", ':lua require"telescope".extensions.dap.commands{}<cr>')
    map("n", "<leader>fdb", ':lua require"telescope".extensions.dap.list_breakpoints{}<cr>')
    map("n", "<leader>fdv", ':lua require"telescope".extensions.dap.variables{}<cr>')
    map("n", "<leader>fdf", ':lua require"telescope".extensions.dap.frames{}<cr>')

    -- load dap configs
    require("dap.python")
    require("dap.go")
  end,
}
return packer_opts
