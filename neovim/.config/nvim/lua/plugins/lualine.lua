local packer_opts = {
  "nvim-lualine/lualine.nvim",
  disable = vim.env.NVIM_EMBEDDED == "true",
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

    local function search_count()
      if vim.api.nvim_get_vvar("hlsearch") == 1 then
        local res = vim.fn.searchcount({ maxcount = 999, timeout = 50 })

        if res.total > 0 then
          -- return string.format("[%s:%d/%d]", vim.fn.getreg("/"), res.current, res.total)
          return string.format("match: %d/%d", res.current, res.total)
        end
      end

      return ""
    end

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
          { search_count, type = "lua_expr" },
        },
        lualine_x = { GetIndicators, "encoding", "filetype" },
        lualine_y = { GetLinePercent, "location" },
        lualine_z = {
          {
            "tabs",
            max_length = vim.o.columns / 3,
            mode = 0,
            tabs_color = {
              active = "lualine_a_normal",
              inactive = "lualine_a_inactive",
            },
          },
        },
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
      a = { bg = palette.magenta, fg = palette.black, gui = "bold" },
      b = { bg = palette.gray, fg = palette.ivory },
      c = { bg = palette.darkgray, fg = palette.lightgray },
    }

    lualine.setup(config)
  end,
}
return packer_opts
