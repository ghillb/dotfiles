require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = gruvbox_custom,
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

local colors = {
  black        = '#282828',
  white        = '#ebdbb2',
  red          = '#fb4934',
  green        = '#b8bb26',
  blue         = '#83a598',
  yellow       = '#fe8019',
  pink         = '#b16286',
  gray         = '#a89984',
  darkgray     = '#3c3836',
  lightgray    = '#504945',
  inactivegray = '#7c6f64',
}

local custom_gruvbox = require'lualine.themes.gruvbox'

custom_gruvbox.normal = {
  a = {bg = colors.gray, fg = colors.black, gui = 'bold'},
  b = {bg = colors.lightgray, fg = colors.white},
  c = {bg = colors.darkgray, fg = colors.gray}
}
custom_gruvbox.insert = {
  a = {bg = colors.blue, fg = colors.black, gui = 'bold'},
  b = {bg = colors.lightgray, fg = colors.white},
  c = {bg = colors.lightgray, fg = colors.white}
}
custom_gruvbox.visual = {
  a = {bg = colors.yellow, fg = colors.black, gui = 'bold'},
  b = {bg = colors.lightgray, fg = colors.white},
  c = {bg = colors.inactivegray, fg = colors.black}
}
custom_gruvbox.terminal = {
  a = {bg = colors.pink, fg = colors.black, gui = 'bold'},
  b = {bg = colors.lightgray, fg = colors.white},
  c = {bg = colors.darkgray, fg = colors.gray}
}
custom_gruvbox.replace = {
  a = {bg = colors.red, fg = colors.black, gui = 'bold'},
  b = {bg = colors.lightgray, fg = colors.white},
  c = {bg = colors.black, fg = colors.white}
}
custom_gruvbox.command = {
  a = {bg = colors.green, fg = colors.black, gui = 'bold'},
  b = {bg = colors.lightgray, fg = colors.white},
  c = {bg = colors.inactivegray, fg = colors.black}
}
custom_gruvbox.inactive = {
  a = {bg = colors.darkgray, fg = colors.gray, gui = 'bold'},
  b = {bg = colors.darkgray, fg = colors.gray},
  c = {bg = colors.darkgray, fg = colors.gray}
}

