local e = vim.fn.expand
local _, overseer = pcall(require, "overseer")

overseer.register_template({
  name = "Terraform init",
  builder = function(params)
    return {
      cmd = {
        "terraform",
        "init",
      },
    }
  end,
  tags = { overseer.TAG.BUILD },
  params = {},
  priority = 50,
  condition = {
    filetype = { "terraform" },
  },
})

_G.run_overseer.terraform = function()
  overseer.run_template({ name = "Terraform init", autostart = false }, function(task)
    if task then
      task:start()
      overseer.run_action(task, 'open hsplit')
    end
  end)
end

