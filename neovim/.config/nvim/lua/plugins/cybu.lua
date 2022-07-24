local packer_opts = {
  "ghillb/cybu.nvim",
  branch = "main",
  config = function()
    require("cybu").setup({
      position = {
        relative_to = "win",
        anchor = "center",
        vertical_offset = -1,
        horizontal_offset = -1,
        max_win_height = 5,
        max_win_width = 0.5,
      },
      style = {
        path = "relative",
        border = "single",
        separator = " ",
        prefix = "..",
        padding = 1,
        hide_buffer_id = true,
        devicons = {
          enabled = true,
          colored = true,
        },
        infobar = {
          enabled = false,
        },
        highlights = {
          current_buffer = "CybuFocus",
          adjacent_buffers = "Comment",
          background = "Normal",
          border = "CybuBorder",
          infobar = "Cursor",
        },
      },
      behavior = {
        mode = {
          default = {
            switch = "immediate",
            view = "rolling",
          },
          last_used = {
            switch = "on_close",
            view = "paging",
          },
        },
      },
      display_time = 750,
      exclude = {
        "neo-tree",
        "fugitive",
        "terminal",
        "qf",
      },
      fallback = function()
        vim.notify("Cybu: Not active in '" .. vim.bo.filetype .. "' filetype.", vim.log.levels.INFO)
      end,
    })
  end,
}
return packer_opts
