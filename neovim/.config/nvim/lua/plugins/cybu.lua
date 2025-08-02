
return function()
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
      path_abbreviation = "none",
      border = "single",
      separator = " ",
      prefix = " ",
      padding = 1,
      hide_buffer_id = true,
      devicons = {
        enabled = true,
        colored = true,
        truncate = true,
      },
      highlights = {
        current_buffer = "Visual",
        adjacent_buffers = "Comment",
        background = "Normal",
      },
    },
    behavior = {
      mode = {
        default = {
          switch = "immediate",
          view = "paging",
        },
        last_used = {
          switch = "on_close",
          view = "paging",
        },
        auto = {
          view = "rolling",
        },
      },
      show_on_autocmd = "BufRead",
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
  
  -- Keybindings
  vim.keymap.set({ "n", "v" }, "]b", "<esc><plug>(CybuLastusedNext)")
  vim.keymap.set({ "n", "v" }, "[b", "<esc><plug>(CybuLastusedPrev)")
  vim.keymap.set("n", "<up>", "<plug>(CybuPrev)")
  vim.keymap.set("n", "<down>", "<plug>(CybuNext)")
end