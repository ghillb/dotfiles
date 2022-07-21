local packer_opts = {
  "sindrets/diffview.nvim",
  disable = vim.env.NVIM_EMBEDDED == "true",
  config = function()
    local ok, diffview = pcall(require, "diffview")
    if not ok then
      return
    end

    local cb = require("diffview.config").diffview_callback
    local config = {
      {
        diff_binaries = false,
        use_icons = false,
        file_panel = {
          width = 35,
        },
        key_bindings = {
          disable_defaults = false,
          view = {
            ["<tab>"] = cb("select_next_entry"),
            ["<s-tab>"] = cb("select_prev_entry"),
            ["<leader>e"] = cb("focus_files"),
            ["<leader>b"] = cb("toggle_files"),
          },
          file_panel = {
            ["j"] = cb("next_entry"),
            ["<down>"] = cb("next_entry"),
            ["k"] = cb("prev_entry"),
            ["<up>"] = cb("prev_entry"),
            ["<cr>"] = cb("select_entry"),
            ["o"] = cb("select_entry"),
            ["l"] = cb("select_entry"),
            ["<2-LeftMouse>"] = cb("select_entry"),
            ["-"] = cb("toggle_stage_entry"),
            ["S"] = cb("stage_all"),
            ["U"] = cb("unstage_all"),
            ["X"] = cb("restore_entry"),
            ["R"] = cb("refresh_files"),
            ["<tab>"] = cb("select_next_entry"),
            ["<s-tab>"] = cb("select_prev_entry"),
            ["<leader>e"] = cb("focus_files"),
            ["<leader>b"] = cb("toggle_files"),
          },
        },
      },
    }

    diffview.setup(config)
  end,
}
return packer_opts
