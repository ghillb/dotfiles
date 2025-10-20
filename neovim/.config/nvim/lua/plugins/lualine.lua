local terminal_extension = {
  sections = {
    lualine_a = { "mode" },
    lualine_b = { { "filename", file_status = false, path = 0 } },
    lualine_y = { "filetype" },
  },
  filetypes = { "terminal" },
}

local misc_extension = {
  sections = {
    lualine_a = { { "filename", file_status = false, path = 0 } },
  },
  filetypes = { "qf" },
}

return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = { left = "|", right = "|" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = false,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = {
        function()
          local ok, project_module = pcall(require, "project_nvim.project")
          if not ok then
            return ""
          end
          return project_module.get_project_root() or ""
        end,
        { "filename", path = 1, newfile_status = true },
      },
      lualine_x = { "diff", "diagnostics" },
      lualine_y = { "filetype" },
      lualine_z = { "%3p%%/%L:%2c" },
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = { terminal_extension, misc_extension },
  },
}
