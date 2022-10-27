local dap = require("dap")
local e = vim.fn.expand

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = "codelldb",
    args = { "--port", "${port}" },
  },
}

dap.adapters.lldb = {
  type = "executable",
  command = "lldb-vscode-14",
  name = "lldb",
}

dap.adapters.cppdbg = {
  id = "cppdbg",
  type = "executable",
  command = "OpenDebugAD7",
}

dap.configurations.rust = {
  {
    name = "Launch file",
    type = "cppdbg", -- codelldb, lldb, cppdbg
    request = "launch",
    program = function()
      return e("%:h:h") .. "/target/debug/" .. e("%:h:h:t")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = true,
    setupCommands = {
      {
        text = "-enable-pretty-printing",
        description = "enable pretty printing",
        ignoreFailures = false,
      },
    },
    preLaunchTask = "Build with cargo",
  },
}
