local packer_opts = {
  "folke/noice.nvim",
  event = "VimEnter",
  config = function()
    require("notify").setup({
      background_colour = "#1E1E1E",
    })
    require("noice").setup({
      views = {
        cmdline_popup = {
          border = {
            style = "single",
          },
          filter_options = {},
          win_options = {
            winhighlight = { Normal = "Normal", FloatBorder = "FloatBorder" },
          },
        },
      },
      popupmenu = {
        enabled = false,
        backend = "nui",
      },
      messages = {
        enabled = true,
        view = "split",
        view_error = "split",
        view_warn = "split",
        view_history = "split",
        view_search = "virtualtext",
      },
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        opts = { buf_options = { filetype = "vim" } },
        format = {
          cmdline = { pattern = "^:", icon = "" },
          search_down = { kind = "search", pattern = "^/", icon = "", ft = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = "", ft = "regex" },
          filter = { pattern = "^:%s*!", icon = "$", ft = "sh" },
          lua = { pattern = "^:%s*lua%s+", icon = "", ft = "lua" },
        },
      },
    })

    vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderCmdline", { link = "Normal" })
  end,
  requires = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
}
return packer_opts
