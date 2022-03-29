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
        lualine_x = {},
        lualine_y = { "filetype" },
        lualine_z = {},
      },
      filetypes = { "terminal" },
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
        lualine_x = { "encoding", "filetype" },
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
      extensions = { terminal_extension, "fugitive", "quickfix" },
    }

    lualine.setup(config)
  end,
}
return packer_opts
