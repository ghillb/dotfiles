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
    local function start_commit_spinner()
      local spinner_frames = { "◜", "◠", "◝", "◞", "◡", "◟" }
      local spinner_idx = 1
      local spinner_msg = "Generating commit message and committing..."
      local notify_opts = { title = "Commit", timeout = false }
      local notification_id = vim.notify(spinner_frames[spinner_idx] .. " " .. spinner_msg, vim.log.levels.INFO, notify_opts)
      local uv = vim.uv or vim.loop
      local spinner_timer = uv and uv.new_timer() or nil

      if spinner_timer then
        spinner_timer:start(100, 100, vim.schedule_wrap(function()
          spinner_idx = (spinner_idx % #spinner_frames) + 1
          notify_opts.id = notification_id
          notification_id = vim.notify(spinner_frames[spinner_idx] .. " " .. spinner_msg, vim.log.levels.INFO, notify_opts)
        end))
      end

      return function(msg, level)
        if spinner_timer then
          spinner_timer:stop()
          spinner_timer:close()
          spinner_timer = nil
        end
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
        vim.opt_local.statuscolumn = ""
        vim.keymap.set("n", "<C-q>", "<cmd>qa<cr>", { buffer = true, desc = "Quit Neovim" })

        vim.keymap.set("n", "C", function()
          local finish_notification = start_commit_spinner()

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
              require('neogit').refresh()
            end
          })
        end, { buffer = true, desc = "Generate AI commit message and commit staged changes" })
      end,
    })
  end,
}
