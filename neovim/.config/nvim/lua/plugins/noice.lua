local packer_opts = {
  "folke/noice.nvim",
  event = "VimEnter",
  config = function()
    require("notify").setup({
      background_colour = "#1E1E1E",
    })
    require("noice").setup({
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
      popupmenu = {
        enabled = false,
      },
      messages = {
        enabled = true,
        view = "mini",
        view_error = "mini",
        view_warn = "mini",
        view_history = "split",
        view_search = "virtualtext",
      },
      lsp_progress = {
        enabled = true,
        throttle = 250,
        view = "mini",
      },
      notify = {
        enabled = true,
        view = "mini",
      },
      views = {
        cmdline_popup = {
          border = {
            style = "single",
          },
          win_options = {
            winhighlight = { Normal = "Normal", FloatBorder = "FloatBorder" },
          },
        },
      },
    })

    vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderCmdline", { link = "Normal" })
    vim.api.nvim_set_hl(0, "NoiceMini", { link = "NormalFloat" })
  end,
  requires = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
}
return packer_opts
