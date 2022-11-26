local e = vim.fn.expand
local _, overseer = pcall(require, "overseer")

overseer.register_template({
  name = "Run python file",
  builder = function(params)
    return {
      cmd = {
        "python",
        vim.api.nvim_buf_get_name(0),
      },
    }
  end,
  tags = {},
  params = {},
  priority = 50,
  condition = {
    filetype = { "python" },
  },
})

_G.overseer_config.run.python = function()
  overseer.run_template({ name = "Run python file", autostart = false }, function(task)
      task:start()
      task:subscribe("on_start", function()
        overseer.run_action(task, "open hsplit, no focus")
        return false
      end)
  end)
end

