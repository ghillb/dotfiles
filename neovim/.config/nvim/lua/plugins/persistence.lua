local packer_opts = {
  "folke/persistence.nvim",
  event = "BufReadPre",
  module = "persistence",
  config = function()
    require("persistence").setup()
  end,
}
return packer_opts
