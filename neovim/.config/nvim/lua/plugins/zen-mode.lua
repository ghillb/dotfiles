return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  keys = {
    { "<leader>tz", ":ZenMode<cr>", desc = "Toggle Zen Mode", silent = true },
  },
  dependencies = { "folke/twilight.nvim" },
  opts = {
    window = {
      backdrop = 0.95,
      width = 120,
      height = 0.95,
      options = {
        signcolumn = "yes",
        number = false,
        relativenumber = false,
        cursorline = false,
        cursorcolumn = false,
        foldcolumn = "0",
        list = false,
      },
    },
    plugins = {
      options = {
        enabled = true,
        ruler = false,
        showcmd = false,
      },
      twilight = { enabled = true },
      gitsigns = { enabled = true },
      tmux = { enabled = true },
      kitty = {
        enabled = false,
        font = "+2",
      },
    },

    on_open = function(win) end,
    on_close = function() end,
  },
}
