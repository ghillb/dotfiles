require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox',
    component_separators = {'', ''},
    section_separators = {'', ''},
    disabled_filetypes = {'fern'}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch','g:git_modified_count' ,'diff'},
    lualine_c = {'g:selective_filename'},
    lualine_x = {'encoding', 'filetype'},
    lualine_y = {'LinePercent'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

