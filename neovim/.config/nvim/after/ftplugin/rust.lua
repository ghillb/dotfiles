local e = vim.fn.expand
local _, overseer = pcall(require, "overseer")

overseer.register_template({
  name = "Compile rust file",
  builder = function(params)
    return {
      cmd = {
        "rustc",
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
    filetype = { "rust" },
  },
})

_G.overseer_config.run.rust = function()
  overseer.run_template({ name = "Run binary", autostart = false }, function(task)
    if task then
      task:add_component({
        "dependencies",
        task_names = {
          "Compile rust file",
        },
        sequential = true,
      })
      task:start()
      task:subscribe("on_start", function()
        overseer.run_action(task, "open hsplit, no focus")
        return false
      end)
    end
  end)
end

_G.overseer_config.build.rust = function()
  overseer.run_template({ name = "Compile rust file", autostart = false }, function(task)
    if task then
      task:start()
      overseer.run_action(task, "open hsplit, no focus")
      vim.cmd.OverseerOpen({ bang = true })
    end
  end)
end
