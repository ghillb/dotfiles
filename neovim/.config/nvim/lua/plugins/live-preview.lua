return {
  "brianhuster/live-preview.nvim",
  cmd = { "LivePreview" },
  dependencies = {
    "folke/snacks.nvim",
  },
  config = function()
    require("livepreview.config").set({
      browser = "true",
      picker = "snacks.picker",
    })
  end,
}
