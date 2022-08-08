local e = vim.fn.expand
local _, overseer = pcall(require, "overseer")

overseer.register_template({
  name = "Docker build",
  builder = function(params)
    return {
      cmd = {
        "podman",
        "build",
        "-t",
        params.image,
        ".",
      },
    }
  end,
  tags = { overseer.TAG.BUILD },
  params = {
    image = {
      type = "string",
      default = "protoype:latest",
      optional = false,
    },
  },
  priority = 50,
  condition = {
    filetype = { "dockerfile" },
  },
})

_G.overseer_config.run.dockerfile = function()
  overseer.run_template({ name = "Docker build", autostart = false, prompt = "always" }, function(task)
    if task then
      task:start()
      overseer.run_action(task, "open hsplit")
    end
  end)
end
