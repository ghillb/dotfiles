local packer_opts = {
  "folke/noice.nvim",
  event = "VimEnter",
  config = function()
    require("notify").setup({
      background_colour = "#1E1E1E",
    })
    require("noice").setup()
  end,
  requires = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
    "hrsh7th/nvim-cmp",
  },
}
return packer_opts
