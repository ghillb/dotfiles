return {
  "folke/persistence.nvim",
  keys = {
    { "<leader>ss", mode = "n" },
    { "<leader>sl", mode = "n" },
    { "<leader>sq", mode = "n" },
  },
  opts = {},
  config = function(_, opts)
    require("persistence").setup(opts)

    -- Keybindings
    vim.keymap.set("n", "<leader>ss", '<cmd>lua require("persistence").load()<cr>')
    vim.keymap.set("n", "<leader>sl", '<cmd>lua require("persistence").load({ last = true })<cr>')
    vim.keymap.set("n", "<leader>sq", '<cmd>lua require("persistence").stop()<cr>')
  end,
}
