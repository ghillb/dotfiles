local packer_opts = {
  "folke/persistence.nvim",
  event = "BufReadPre",
  module = "persistence",
  config = function()
    if vim.env.NVIM_INIT then return end
    require("persistence").setup()
  end,
}
return packer_opts
