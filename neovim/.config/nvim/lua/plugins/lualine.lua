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

    local function git_modified_files_count()
      if user.fn.is_git_work_tree() then
        return tonumber(vim.fn.system('git diff --numstat | wc -l | tr -d "\n"')) or ""
      else
        return ""
      end
    end

    local function get_indicators()
      local indicators = ""
      for _, indicator in pairs(user.indicators) do
        indicators = indicators .. indicator
      end
      return indicators
    end

    local function get_line_percent()
      return math.floor(vim.fn.line(".") * 100 / vim.fn.line("$")) .. "%%"
    end

    local breadcrump_sep = "  "
    local filename_extension = {
      "filename",
      path = 1,
      separator = vim.trim(breadcrump_sep),
      fmt = function(str)
        local path_separator = package.config:sub(1, 1)
        return str:gsub(path_separator, breadcrump_sep)
      end,
      color = { fg = nil, bg = nil, gui = "italic" },
    }

    local config = {
      options = {
        icons_enabled = true,
        theme = "gruvbox",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {
            "git",
            "fugitive",
            "alpha",
            "packer",
            "neo-tree",
            "Trouble",
            "spectre_panel",
            "terminal",
            "neoterm",
            "qf",
            "glowpreview",
          },
        },
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", { git_modified_files_count, type = "lua_expr" }, "diff" },
        lualine_c = {
          { "overseer" },
          {
            function()
              return require("nvim-lightbulb").get_status_text()
            end,
            type = "lua_expr",
          },
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
        lualine_x = { get_indicators, "encoding", "filetype" },
        lualine_y = { get_line_percent, "location" },
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
      winbar = {
        lualine_b = {
          filename_extension,
          { "aerial", sep = breadcrump_sep, color = { fg = _G.palette.pink, bg = nil, gui = "italic,bold" } },
        },
      },
      inactive_winbar = {
        lualine_c = {
          filename_extension,
          { "aerial", sep = breadcrump_sep, color = { fg = nil, bg = nil, gui = "italic,bold" } },
        },
      },

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
