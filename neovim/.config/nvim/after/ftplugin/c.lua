vim.g.asynctasks_profile = "vim"
vim.opt_local.cmdheight = 0

local e = vim.fn.expand
local _, overseer = pcall(require, "overseer")

overseer.register_template({
  name = "Compile C++ with gdb flag",
  builder = function(params)
    return {
      cmd = {
        "g++",
        "-g",
        vim.api.nvim_buf_get_name(0),
        "-o",
        string.format("%s.out", e("%:p:r")),
      },
    }
  end,
  tags = { overseer.TAG.BUILD },
  params = {},
  priority = 50,
  condition = {
    filetype = { "c", "cpp" },
  },
})

local run_template = function()
  overseer.run_template({ name = "Run binary", autostart = false }, function(task)
    if task then
      task:add_component({
        "dependencies",
        task_names = {
          "Compile C++ with gdb flag",
        },
        sequential = true,
      })
      task:start()
      vim.cmd("OverseerOpen!")
    end
  end)
end

vim.keymap.set("n", "<a-s-o>", run_template)
