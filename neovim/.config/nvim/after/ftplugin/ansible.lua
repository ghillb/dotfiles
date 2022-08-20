local e = vim.fn.expand
local _, overseer = pcall(require, "overseer")

overseer.register_template({
  name = "Run ansible playbook",
  builder = function(params)
    return {
      cmd = {
        "ansible-playbook",
        "-i",
        vim.env.ANSIBLE_INVENTORY,
        e("%:p"),
      },
    }
  end,
  params = {},
  priority = 50,
  condition = {
    filetype = { "ansible.yaml" },
  },
})

_G.overseer_config.run["ansible.yaml"] = function()
  overseer.run_template({ name = "Run ansible playbook", autostart = false }, function(task)
    if task then
      task:start()
      overseer.run_action(task, "open tab")
      vim.cmd.OverseerOpen({ bang = true })
    end
  end)
end
