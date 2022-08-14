_G.palette = {
  black = "#282828",
  red = "#fb4934",
  yellow = "#fabd2f",
  blue = "#448488",
  green = "#989719",
  aqua = "#8ec07c",
  magenta = "#b16286",
  pink = "#d4879c",
  ivory = "#ebdbb2",
  lightgray = "#a89984",
  gray = "#504945",
  darkgray = "#3c3836",
}

local function set_global_theme()
  local function set_hl(hl_group, value)
    vim.api.nvim_set_hl(0, hl_group, value)
  end

  -- vim highlight groups
  set_hl("Border", { fg = palette.darkgray })
  set_hl("FloatBorder", { fg = palette.darkgray })
  set_hl("EndOfBuffer", { fg = palette.darkgray })
  set_hl("FoldColumn", { fg = palette.gray })
  set_hl("VertSplit", { bg = nil, fg = palette.darkgray })
  set_hl("TabLineFill", { bg = nil })
  set_hl("DiagnosticError", { fg = palette.red })
  -- plugin highlight groups
  set_hl("GitSignsAdd", { bg = nil, fg = palette.green })
  set_hl("GitSignsAddLn", { bg = nil, fg = palette.green })
  set_hl("GitSignsChange", { bg = nil, fg = palette.blue })
  set_hl("GitSignsDelete", { bg = nil, fg = palette.red })
  set_hl("GitSignsDeleteLn", { bg = nil, fg = palette.red })
  set_hl("TelescopePromptBorder", { fg = palette.darkgray })
  set_hl("TelescopeResultsBorder", { fg = palette.darkgray })
  set_hl("TelescopePreviewBorder", { fg = palette.darkgray })
end

vim.api.nvim_create_autocmd("colorscheme", {
  callback = function()
    set_global_theme()
  end,
})

-- gruvbox
local ok, gruvbox_colors = pcall(require, "gruvbox-baby.colors")
if not ok then
  return
end

local gbc = gruvbox_colors.config()

vim.g.gruvbox_baby_transparent_mode = 1
vim.g.gruvbox_baby_background_color = "dark"
vim.g.gruvbox_baby_highlights = {
  Cursor = { fg = gbc.background_dark, bg = gbc.pink },
  Search = { fg = gbc.background_dark, bg = gbc.bright_yellow, style = "NONE" },
  IncSearch = { fg = gbc.background_dark, bg = gbc.blue_gray },
  SpellBad = { style = "undercurl" },
  MsgArea = { fg = gbc.milk },
  NormalFloat = { bg = gbc.background_light },
  diffLine = { fg = gbc.dark_gray },
  DiffDelete = { fg = gbc.red },
  Identifier = { fg = gbc.pink },
  PreProc = { fg = gbc.dark_gray },
  QuickFixLine = { fg = gbc.dark_gray, bg = gbc.medium_gray },
  TSConstructor = { fg = gbc.clean_green },
  TSPunctBracket = { fg = gbc.orange },
  Boolean = { fg = gbc.pink },
  Keyword = { fg = gbc.bright_yellow },
  MatchParen = { fg = gbc.background_dark, bg = gbc.orange },
  Visual = { bg = gbc.medium_gray },
  fugitiveUntrackedHeading = { fg = gbc.background_dark, bg = gbc.orange },
  fugitiveUntrackedModifier = { fg = gbc.orange },
  fugitiveUntrackedSection = { fg = gbc.pink },
  fugitiveUnstagedHeading = { fg = gbc.background_dark, bg = gbc.soft_yellow },
  fugitiveUnstagedSection = { fg = gbc.pink },
  fugitiveStagedHeading = { fg = gbc.background_dark, bg = gbc.forest_green },
  fugitiveStagedSection = { fg = gbc.pink },
  fugitiveSymbolicRef = { fg = gbc.magenta },
  gitcommitHeader = { fg = gbc.dark_gray },
  gitcommitBranch = { fg = gbc.magenta },
  gitcommitFile = { fg = gbc.pink },
  debugPc = { bg = gbc.background },
  cppTSVariable = { fg = gbc.light_blue },
}

-- kanagawa
require("kanagawa").setup({
  undercurl = true,
  specialReturn = true,
  specialException = true,
  transparent = true,
  colors = {},
  overrides = {},
})

-- onedark
require("onedark").setup({
  style = "darker",
  transparent = true,
})

-- nightfox
require("nightfox").setup({
  options = {
    transparent = true,
  },
})

-- enable colorscheme
vim.cmd([[ silent! colorscheme gruvbox-baby ]])
-- vim.cmd([[ silent! colorscheme kanagawa ]])
-- vim.cmd([[ silent! colorscheme onedark ]])
-- vim.cmd([[ silent! colorscheme nightfox ]])
