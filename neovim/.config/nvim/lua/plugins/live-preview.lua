return {
  "brianhuster/live-preview.nvim",
  cmd = { "LivePreview" },
  keys = {
    { "<leader>mp", "<cmd>silent LivePreview start<cr>", desc = "Preview Markdown in browser" },
  },
  dependencies = {
    "folke/snacks.nvim",
  },
  config = function()
    require("livepreview.config").set({
      browser = "default",
      picker = "snacks.picker",
    })
  end,
}
