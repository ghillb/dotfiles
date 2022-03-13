local packer_opts = {
  "folke/twilight.nvim",
  config = function()
    if vim.env.NVIM_INIT then return end
    local twilight = require("twilight")

    local config = {
      dimming = {
        alpha = 0.25,
        color = { "Normal", "#ffffff" },
      },
      context = 10,
      expand = {
        "function",
        "method",
        "table",
        "if_statement",
      },
      exclude = {},
    }

    twilight.setup(config)
  end,
}
return packer_opts
