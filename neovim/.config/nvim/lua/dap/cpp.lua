local dap = require("dap")
dap.adapters.cpp = {
  type = "executable",
  command = "lldb-vscode-14",
  env = {
    LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "NO",
  },
  name = "lldb",
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "cpp",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    args = {},
  },
}

dap.configurations.c = dap.configurations.cpp
