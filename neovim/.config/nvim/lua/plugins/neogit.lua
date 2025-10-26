return {
  "NeogitOrg/neogit",
  cmd = "Neogit",
  keys = {
    { "<a-g>", "<cmd>Neogit<cr>", desc = "Neogit status" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
  },
  config = function()
    local neogit = require("neogit")

    neogit.setup({
      disable_signs = false,
      disable_hint = false,
      disable_context_highlighting = false,
      disable_commit_confirmation = false,
      auto_refresh = true,
      sort_branches = "-committerdate",
      disable_builtin_notifications = false,
      use_magit_keybindings = false,
      kind = "tab",
      console_timeout = 2000,
      auto_show_console = true,
      commit_popup = {
        kind = "split",
      },
      signs = {
        section = { ">", "v" },
        item = { ">", "v" },
        hunk = { "", "" },
      },
      integrations = {
        diffview = true,
      },
      sections = {
        untracked = {
          folded = false,
          hidden = false
        },
        unstaged = {
          folded = false,
          hidden = false
        },
        staged = {
          folded = false,
          hidden = false
        },
        stashes = {
          folded = true,
          hidden = false
        },
        unpulled = {
          folded = true,
          hidden = false
        },
        unmerged = {
          folded = false,
          hidden = false
        },
        recent = {
          folded = true,
          hidden = false
        },
      },
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "NeogitStatus", "NeogitCommitView" },
      callback = function()
        vim.keymap.set("n", "<C-q>", "<cmd>qa<cr>", { buffer = true, desc = "Quit Neovim" })

        vim.keymap.set("n", "C", function()
          vim.notify("Generating commit message and committing...", vim.log.levels.INFO)

          user.fn.generate_commit_msg({
            commit = true,
            callback = function(success, result)
              if not success then
                if result:match("No staged changes") then
                  vim.notify("No staged changes found. Stage some changes first.", vim.log.levels.WARN)
                else
                  vim.notify(result, vim.log.levels.ERROR)
                end
                return
              end

              vim.notify("Committed successfully!", vim.log.levels.INFO)
              require('neogit').refresh()
            end
          })
        end, { buffer = true, desc = "Generate AI commit message and commit staged changes" })
      end,
    })
  end,
}
