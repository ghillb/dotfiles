local packer_opts = {
  "mfussenegger/nvim-dap",
  disable = vim.env.NVIM_EMBEDDED == "true",
  requires = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "jbyuki/one-small-step-for-vimkind",
  },
  config = function()
    local ok, dap = pcall(require, "dap")
    if not ok then
      return
    end

    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "Define", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◯", texthl = "Define", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "→", texthl = "Define", linehl = "", numhl = "" })

    -- nvim-dap-ui setup
    local dap_ui = require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dap_ui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dap_ui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dap_ui.close()
    end

    local config_dap_ui = {
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.5 },
            { id = "breakpoints", size = 0.125 },
            { id = "stacks", size = 0.125 },
            { id = "watches", size = 0.25 },
          },
          size = 50,
          position = "left",
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 0.25,
          position = "bottom",
        },
      },
    }
    dap_ui.setup(config_dap_ui)

    local dap_virtual_text = require("nvim-dap-virtual-text")

    -- nvim-dap-virtual-text setup
    local config_dap_vt = {
      enabled = false,
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
    map("n", "<F13>", function()
      dap.run(dap.configurations.cpp[1])
    end)
    map("n", "<F2>", ":lua require('dap').step_over()<cr>")
    map("n", "<F14>", ":lua require('dap').step_back()<cr>")
    map("n", "<F3>", ":lua require('dap').step_into()<cr>")
    map("n", "<F4>", ":lua require('dap').step_out()<cr>")
    map("n", "<F5>", ":lua require('dap').toggle_breakpoint()<cr>")
    map("n", "<F17>", ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>")
    map("n", "<F29>", ":lua require('dap').set_breakpoint({ nil, nil, vim.fn.input('Log point message: ')})<cr>")
    map("n", "<F10>", ":lua require('dapui').toggle()<cr>")
    map("n", "<F22>", ":lua require('dap').repl.toggle()<cr>")

    map("n", "<leader>fdc", ':lua require"telescope".extensions.dap.commands{}<cr>')
    map("n", "<leader>fdb", ':lua require"telescope".extensions.dap.list_breakpoints{}<cr>')
    map("n", "<leader>fdv", ':lua require"telescope".extensions.dap.variables{}<cr>')
    map("n", "<leader>fdf", ':lua require"telescope".extensions.dap.frames{}<cr>')

    -- load dap configs
    require("dap.python")
    require("dap.go")
    require("dap.lua")
    require("dap.cpp")
  end,
}
return packer_opts
