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
    local function start_commit_notification()
      local notify_opts = { title = "Commit", timeout = false }
      local notification_id =
        vim.notify("Generating commit message and committing...", vim.log.levels.INFO, notify_opts)

      return function(msg, level)
        notify_opts.id = notification_id
        notify_opts.timeout = 3000
        vim.notify(msg, level, notify_opts)
      end
    end

    neogit.setup({
      disable_signs = false,
      disable_hint = false,
      disable_context_highlighting = false,
      disable_commit_confirmation = false,
      auto_refresh = true,
      graph_style = "unicode",
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
        section = { "", "" },
        item = { "", "" },
        hunk = { "", "" },
      },
      integrations = {
        diffview = true,
      },
      sections = {
        untracked = {
          folded = false,
          hidden = false,
        },
        unstaged = {
          folded = false,
          hidden = false,
        },
        staged = {
          folded = false,
          hidden = false,
        },
        stashes = {
          folded = true,
          hidden = false,
        },
        unpulled = {
          folded = true,
          hidden = false,
        },
        unmerged = {
          folded = false,
          hidden = false,
        },
        recent = {
          folded = true,
          hidden = false,
        },
      },
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "NeogitStatus", "NeogitCommitView" },
      callback = function(args)
        vim.b[args.buf].snacks_statuscolumn_right = false

        vim.keymap.set("n", "<C-q>", "<cmd>qa<cr>", { buffer = true, desc = "Quit Neovim" })

        vim.keymap.set("n", "C", function()
          local finish_notification = start_commit_notification()

          user.fn.generate_commit_msg({
            commit = true,
            callback = function(success, result)
              if not success then
                if result:match("No staged changes") then
                  finish_notification("No staged changes found. Stage some changes first.", vim.log.levels.WARN)
                else
                  finish_notification(result, vim.log.levels.ERROR)
                end
                return
              end

              finish_notification("Committed successfully!", vim.log.levels.INFO)
              require("neogit").refresh()
            end,
          })
        end, { buffer = true, desc = "Generate AI commit message and commit staged changes" })
      end,
    })
  end,
}
