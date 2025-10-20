return {
  "folke/twilight.nvim",
  cmd = "Twilight",
  keys = {
    { "<leader>tw", ":Twilight<cr>", desc = "Toggle Twilight", silent = true },
  },
  opts = {
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
  },
}
