local packer_opts = {
  "mfussenegger/nvim-dap",
  requires = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "Pocco81/DAPInstall.nvim",
  },
  config = function()
    local ok, dap_ui = pcall(require, "dap_ui")
    if not ok then
      return
    end

    dap_ui.setup()
    local dap_virtual_text = require("nvim-dap-virtual-text")

    -- nvim-dap-virtual-text setup
    local config = {
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      virt_text_pos = "eol",
    }

    dap_virtual_text.setup(config)

    -- nvim-dap-install setup
    local dap_install = require("dap-install")

    dap_install.setup({
      installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
    })

    local dbg_list = require("dap-install.api.debuggers").get_installed_debuggers()

    for _, debugger in ipairs(dbg_list) do
      dap_install.config(debugger)
    end

    local map = vim.keymap.set

    map("n", "<F1>", ":lua require('dap').continue()<cr>")
    map("n", "<F2>", ":lua require('dap').step_over()<cr>")
    map("n", "<F3>", ":lua require('dap').step_into()<cr>")
    map("n", "<F4>", ":lua require('dap').step_out()<cr>")
    map("n", "<F5>", ":lua require('dap').toggle_breakpoint()<cr>")
    map("n", "<F10>", ":lua require('dapui').toggle()<cr>")

    map("n", "<Leader>dbc", ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>")
    map("n", "<Leader>dbm", ":lua require('dap').set_breakpoint({ nil, nil, vim.fn.input('Log point message: ')})<cr>")

    map("n", "<Leader>dsc", ":lua require('dap').continue()<cr>")
    map("n", "<Leader>dsv", ":lua require('dap').step_over()<cr>")
    map("n", "<Leader>dsi", ":lua require('dap').step_into()<cr>")
    map("n", "<Leader>dso", ":lua require('dap').step_out()<cr>")

    map("n", "<Leader>dtr", ":lua require('dap').repl.open()<cr>")
    map("n", "<Leader>dtu", ":lua require('dapui').toggle()<cr>")
    map("n", "<Leader>dtv", ":lua local widgets=require('dap.ui.widgets');widgets.centered_float(widgets.scopes)<cr>")

    map("n", "<leader>fdc", ':lua require"telescope".extensions.dap.commands{}<cr>')
    map("n", "<leader>fdb", ':lua require"telescope".extensions.dap.list_breakpoints{}<cr>')
    map("n", "<leader>fdv", ':lua require"telescope".extensions.dap.variables{}<cr>')
    map("n", "<leader>fdf", ':lua require"telescope".extensions.dap.frames{}<cr>')
  end,
}
return packer_opts
