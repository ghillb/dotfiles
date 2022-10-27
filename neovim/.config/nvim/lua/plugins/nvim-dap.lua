local packer_opts = {
  "mfussenegger/nvim-dap",
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

    map("n", "<F1>", function()
      require("dap").continue()
    end)
    map("n", "<F13>", function()
      dap.run(dap.configurations[vim.bo.filetype][1])
    end)
    map("n", "<F2>", function()
      require("dap").step_over()
    end)
    map("n", "<F14>", function()
      require("dap").step_back()
    end)
    map("n", "<F3>", function()
      require("dap").step_into()
    end)
    map("n", "<F4>", function()
      require("dap").step_out()
    end)
    map("n", "<F5>", function()
      require("dap").toggle_breakpoint()
    end)
    map("n", "<F17>", function()
      require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end)
    map("n", "<F29>", function()
      require("dap").set_breakpoint({ nil, nil, vim.fn.input("Log point message: ") })
    end)
    map("n", "<F10>", function()
      require("dapui").toggle()
    end)
    map("n", "<F22>", function()
      require("dap").repl.toggle()
    end)

    map("n", "<leader>fdc", function()
      require("telescope").extensions.dap.commands({})
    end)
    map("n", "<leader>fdb", function()
      require("telescope").extensions.dap.list_breakpoints({})
    end)
    map("n", "<leader>fdv", function()
      require("telescope").extensions.dap.variables({})
    end)
    map("n", "<leader>fdf", function()
      require("telescope").extensions.dap.frames({})
    end)

    -- load dap configs
    require("dap.python")
    require("dap.go")
    require("dap.lua")
    require("dap.cpp")
    require("dap.rust")
  end,
}
return packer_opts
