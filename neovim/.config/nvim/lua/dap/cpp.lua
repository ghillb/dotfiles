local dap = require("dap")
local setupCommands = {
  {
    text = "-enable-pretty-printing",
    description = "enable pretty printing",
    ignoreFailures = false,
  },
}

dap.adapters.cppdbg = {
  id = "cppdbg",
  type = "executable",
  command = "OpenDebugAD7",
}

dap.configurations.cpp = {
  {
    name = "Launch current file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.expand("%:p:r") .. ".out"
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = true,
    setupCommands = setupCommands,
  },
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = true,
    setupCommands = setupCommands,
  },
  {
    name = "Attach to gdbserver :1234",
    type = "cppdbg",
    request = "launch",
    MIMode = "gdb",
    miDebuggerServerAddress = "localhost:1234",
    miDebuggerPath = "/usr/bin/gdb",
    cwd = "${workspaceFolder}",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    setupCommands = setupCommands,
  },
}

dap.configurations.c = dap.configurations.cpp
