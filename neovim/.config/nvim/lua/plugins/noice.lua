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
            style = "none",
          },
          filter_options = {},
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          },
        },
      },
      popupmenu = {
        enabled = false,
        backend = "cmp",
      },
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        opts = { buf_options = { filetype = "vim" } },
        icons = {
          ["/"] = { icon = " ", hl_group = "DiagnosticWarn" },
          ["?"] = { icon = " ", hl_group = "DiagnosticWarn" },
          [":"] = { icon = "⮞ ", hl_group = "DiagnosticError", firstc = false },
        },
      },
    })
  end,
  requires = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
    "hrsh7th/nvim-cmp",
  },
}
return packer_opts
