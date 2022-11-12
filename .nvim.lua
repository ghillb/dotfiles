function _G.set_project_settings()
  local ok, overseer = pcall(require, "overseer")
  if not ok then
    return
  end

  overseer.register_template({
    name = "Run project",
    builder = function(params)
      return {
        cmd = {
          "echo",
          "TODO",
        },
      }
    end,
    priority = 50,
  })

  _G.overseer_config.project = function()
    overseer.run_template({ name = "Run project", autostart = false }, function(task)
      if task then
        task:start()
        task:subscribe("on_start", function()
          overseer.run_action(task, "open hsplit, no focus")
          return false
        end)
        vim.cmd.OverseerOpen({ bang = true })
      end
    end)
  end
end
