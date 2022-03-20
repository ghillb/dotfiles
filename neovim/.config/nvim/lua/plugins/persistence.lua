local packer_opts = {
  "folke/persistence.nvim",
  event = "BufReadPre",
  module = "persistence",
  config = function()
    local ok, persistence = pcall(require, "persistence")
    if not ok then
      return
    end

    persistence.setup()
  end,
}
return packer_opts
