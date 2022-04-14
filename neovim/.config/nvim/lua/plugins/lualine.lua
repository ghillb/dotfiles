local packer_opts = {
  "nvim-lualine/lualine.nvim",
  opt = false,
  config = function()
    local ok, lualine = pcall(require, "lualine")
    if not ok then
      return
    end

    local terminal_extension = {
      sections = {
        lualine_a = { "mode" },
        lualine_b = { { "filename", file_status = false, path = 0 } },
        lualine_y = { "filetype" },
      },
      filetypes = { "terminal" },
    }

    local neotree_extension = {
      sections = {
        lualine_a = { { "filename", file_status = false, path = 0 } },
      },
      filetypes = { "neo-tree" },
    }

    local config = {
      options = {
        icons_enabled = true,
        theme = "gruvbox",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "g:git_modified_count", "diff" },
        lualine_c = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = {
              error = _G.DiagnosticSigns.Error,
              warn = _G.DiagnosticSigns.Warn,
              hint = _G.DiagnosticSigns.Hint,
              info = _G.DiagnosticSigns.Info,
            },
          },
          "g:breadcrumbs",
        },
        lualine_x = { GetIndicators, "encoding", "filetype" },
        lualine_y = { GetLinePercent },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { terminal_extension, neotree_extension, "fugitive", "quickfix" },
    }

    local gruvbox = require("lualine.themes.gruvbox")

    gruvbox.terminal = {
      a = { bg = palette.pink, fg = palette.black, gui = "bold" },
      b = { bg = palette.gray, fg = palette.ivory },
      c = { bg = palette.darkgray, fg = palette.lightgray },
    }

    lualine.setup(config)
  end,
}
return packer_opts
