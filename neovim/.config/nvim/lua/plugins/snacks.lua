return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    { "<leader>n", function() require("snacks").notifier.show_history() end, desc = "Notification History" },
    { "<leader>gb", function() require("snacks").git.blame_line() end, desc = "Git Blame Line" },
    { "<leader>gB", function() require("snacks").gitbrowse() end, desc = "Git Browse" },
    { "<leader>un", function() require("snacks").notifier.hide() end, desc = "Dismiss All Notifications" },
    { "]]", function() require("snacks").words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[", function() require("snacks").words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for easy access
        _G.dd = function(...)
          require("snacks").debug.inspect(...)
        end
        _G.bt = function()
          require("snacks").debug.backtrace()
        end
        vim.print = _G.dd
      end,
    })
  end,
}
