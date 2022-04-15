_G.palette = {
  black = "#282828",
  red = "#fb4934",
  yellow = "#fabd2f",
  blue = "#448488",
  green = "#989719",
  aqua = "#8ec07c",
  pink = "#b16286",
  ivory = "#ebdbb2",
  lightgray = "#a89984",
  gray = "#504945",
  darkgray = "#3c3836",
}

local function set_theme()
  local function set_hl(hl_group, value)
    vim.api.nvim_set_hl(0, hl_group, value)
  end

  -- vim highlight groups
  set_hl("Border", { fg = palette.darkgray })
  set_hl("EndOfBuffer", { fg = palette.darkgray })
  set_hl("VertSplit", { bg = nil, fg = palette.darkgray })
  set_hl("NormalFloat", { bg = nil })
  set_hl("TabLineFill", { bg = nil })
  set_hl("DiagnosticError", { fg = palette.red })
  -- plugin highlight groups
  set_hl("GitSignsAdd", { bg = nil, fg = palette.green })
  set_hl("GitSignsChange", { bg = nil, fg = palette.blue })
  set_hl("GitSignsDelete", { bg = nil, fg = palette.red })
  set_hl("TelescopePromptBorder", { fg = palette.darkgray })
  set_hl("TelescopeResultsBorder", { fg = palette.darkgray })
  set_hl("TelescopePreviewBorder", { fg = palette.darkgray })
end

vim.api.nvim_create_autocmd("colorscheme", {
  callback = function()
    set_theme()
  end,
})

-- gruvbox setup
local ok, gruvbox_colors = pcall(require, "gruvbox-baby.colors")
if not ok then
  return
end

local gb_colors = gruvbox_colors.config()

vim.g.gruvbox_baby_transparent_mode = 1
vim.g.gruvbox_baby_background_color = "dark"
vim.g.gruvbox_baby_highlights = {
  Search = { fg = gb_colors.background_dark, bg = gb_colors.bright_yellow, style = "NONE" },
  IncSearch = { fg = gb_colors.background_dark, bg = gb_colors.blue_gray },
  SpellBad = { style = "undercurl" },
  diffLine = { fg = gb_colors.dark_gray },
  DiffDelete = { fg = gb_colors.red },
  DiffAdd = { fg = gb_colors.forest_green },
  Identifier = { fg = gb_colors.pink },
  PreProc = { fg = gb_colors.dark_gray },
  QuickFixLine = { fg = gb_colors.dark_gray, bg = gb_colors.medium_gray },
  TSConstructor = { fg = gb_colors.clean_green },
  TSPunctBracket = { fg = gb_colors.orange },
  Boolean = { fg = gb_colors.pink },
  MatchParen = { fg = gb_colors.background_dark, bg = gb_colors.orange },
  fugitiveUntrackedHeading = { fg = gb_colors.background_dark, bg = gb_colors.orange },
  fugitiveUntrackedModifier = { fg = gb_colors.orange },
  fugitiveUntrackedSection = { fg = gb_colors.pink },
  fugitiveUnstagedHeading = { fg = gb_colors.background_dark, bg = gb_colors.soft_yellow },
  fugitiveUnstagedSection = { fg = gb_colors.pink },
  fugitiveStagedHeading = { fg = gb_colors.background_dark, bg = gb_colors.forest_green },
  fugitiveStagedSection = { fg = gb_colors.pink },
  fugitiveSymbolicRef = { fg = gb_colors.magenta },
  LightspeedCursor = { fg = gb_colors.background_dark, bg = gb_colors.pink },
}

-- kanagawa setup
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

require("kanagawa").setup(config)

-- onedark setup
require("onedark").setup({
  style = "darker",
  transparent = true,
})

-- nightfox setup
require("nightfox").setup({
  options = {
    transparent = true,
  },
})

-- tokyonight setup
vim.g.tokyonight_style = "night"
vim.g.tokyonight_transparent = true

-- enable colorscheme
vim.cmd([[ silent! colorscheme gruvbox-baby ]])
-- vim.cmd([[ silent! colorscheme kanagawa ]])
-- vim.cmd([[ silent! colorscheme onedark ]])
-- vim.cmd([[ silent! colorscheme nightfox ]])
-- vim.cmd([[ silent! colorscheme tokyonight ]])
