-- supress clangd warning about multiple different client offset_encodings
-- https://github.com/folke/noice.nvim/discussions
local notify = vim.notify
vim.notify = function(msg, ...)
  if msg:match("warning: multiple different client offset_encodings") then
    return
  end
  notify(msg, ...)
end

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

_G.overseer_config.run.cpp = function()
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
      task:subscribe("on_start", function()
        overseer.run_action(task, "open hsplit, no focus")
        return false -- this will unsubscribe the callback
      end)
      vim.cmd.OverseerOpen({ bang = true })
    end
  end)
end

_G.overseer_config.build.cpp = function()
  overseer.run_template({ name = "Compile C++ with gdb flag", autostart = false }, function(task)
    if task then
      task:start()
      overseer.run_action(task, "open hsplit, no focus")
      vim.cmd.OverseerOpen({ bang = true })
    end
  end)
end
