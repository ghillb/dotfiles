local e = vim.fn.expand
local _, overseer = pcall(require, "overseer")

overseer.register_template({
  name = "Terraform",
  builder = function(params)
    return {
      cmd = {
        "terraform",
        params.action,
      },
    }
  end,
  params = {
    action = {
      type = "enum",
      default = "apply",
      choices = {
        "init",
        "plan",
        "apply",
        "destroy",
        "graph",
        "refresh",
        "show",
        "validate",
      },
    },
  },
  priority = 50,
  condition = {
    filetype = { "terraform" },
  },
})

_G.run_overseer.terraform = function()
  overseer.run_template({ name = "Terraform", autostart = false, prompt = "always" }, function(task)
    if task then
      task:start()
      overseer.run_action(task, "open hsplit")
    end
  end)
end
