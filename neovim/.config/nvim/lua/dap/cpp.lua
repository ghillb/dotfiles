local dap = require("dap")

local setupCommands = {
  {
    text = "-enable-pretty-printing",
    description = "enable pretty printing",
    ignoreFailures = false,
  },
}

local preLaunchTask = function()
  return string.format("g++ -g %s -o %s.out", vim.fn.expand("%:p"), vim.fn.expand("%:p:r"))
end

dap.adapters.cppdbg = function(cb, config)
  if config.preLaunchTask then
    vim.fn.system(config.preLaunchTask)
  end
  local adapter = {
    id = "cppdbg",
    type = "executable",
    command = "OpenDebugAD7",
  }
  cb(adapter)
end

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = "codelldb",
    args = { "--port", "${port}" },
  },
}

dap.configurations.cpp = {
  {
    name = "Launch current file (cppdbg)",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.expand("%:p:r") .. ".out"
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = true,
    setupCommands = setupCommands,
    preLaunchTask = preLaunchTask,
  },
  {
    name = "Launch current file (codelldb)",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.expand("%:p:r") .. ".out"
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = true,
    setupCommands = setupCommands,
    preLaunchTask = preLaunchTask,
  },
  {
    name = "Launch file (cppdbg)",
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
    name = "Attach to gdbserver :1234 (cppdbg)",
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
