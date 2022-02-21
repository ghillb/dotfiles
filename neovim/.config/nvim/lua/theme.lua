_G.palette = {
  red = "#fb4934",
  yellow = "#fabd2f",
  blue = "#448488",
  green = "#989719",
  aqua = "#8ec07c",
  pink = "#b16286",
  ivory = "#ebdbb2",
  gray = "#3c3836",
}

function _G.SetTheme()
  local function set_hl(hl_group, value)
    vim.api.nvim_set_hl(0, hl_group, value)
  end

  -- vim highlight groups
  set_hl("Border", { fg = palette.gray })
  set_hl("SignColumn", { bg = nil })
  set_hl("NormalFloat", { bg = nil })
  set_hl("StatusLine", { fg = palette.gray })
  set_hl("EndOfBuffer", { fg = palette.gray })
  set_hl("VertSplit", { bg = nil, fg = palette.gray })
  set_hl("WarningMsg", { fg = palette.red })
  set_hl("TabLineSel", { fg = palette.ivory })
  set_hl("TabLineFill", { bg = nil })
  set_hl("TabLine", { bg = nil })
  -- plugin highlight groups
  set_hl("GitSignsAdd", { bg = nil, fg = palette.green })
  set_hl("GitSignsChange", { bg = nil, fg = palette.blue })
  set_hl("GitSignsDelete", { bg = nil, fg = palette.red })
  set_hl("TelescopePromptBorder", { fg = palette.gray })
  set_hl("TelescopeResultsBorder", { fg = palette.gray })
  set_hl("TelescopePreviewBorder", { fg = palette.gray })
  set_hl("NvimTreeNormal", { bg = nil })
  set_hl("NvimTreeIndentMarker", { fg = palette.gray })
  set_hl("GruvboxRedSign", { bg = nil, fg = palette.red })
  set_hl("GruvboxYellowSign", { bg = nil, fg = palette.yellow })
  set_hl("GruvboxBlueSign", { bg = nil, fg = palette.blue })
  set_hl("GruvboxAquaSign", { bg = nil, fg = palette.aqua })
end

-- set theme, for some reason 'Normal' has to be set the old way
-- vim.api.nvim_set_hl(0, "Normal", { bg = nil })
vim.cmd([[au colorscheme * hi Normal guibg=NONE ctermbg=NONE]])
vim.cmd([[au colorscheme * lua SetTheme()]])

-- gruvbox setup
vim.g.gruvbox_contrast_dark = "hard"
vim.g.gruvbox_invert_selection = 0

-- kanagawa setup
local ok, kanagawa = pcall(require, "kanagawa")
if not ok then
  return
end

local config = {
  undercurl = true,
  commentStyle = "italic",
  functionStyle = "NONE",
  keywordStyle = "italic",
  statementStyle = "bold",
  typeStyle = "NONE",
  variablebuiltinStyle = "italic",
  specialReturn = true,
  specialException = true,
  transparent = true,
  colors = {},
  overrides = {},
}

kanagawa.setup(config)

-- onedark setup
require("onedark").setup({
  style = "darker",
  transparent = true,
})

-- tokyonight setup
vim.g.tokyonight_style = "night"
vim.g.tokyonight_transparent = true

-- enable colorscheme
vim.cmd([[ silent! colorscheme gruvbox ]])
-- vim.cmd([[ silent! colorscheme kanagawa ]])
-- vim.cmd([[ silent! colorscheme onedark ]])
-- vim.cmd([[ silent! colorscheme tokyonight ]])
