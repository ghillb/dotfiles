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

  set_hl("Border", { fg = palette.darkgray })
  set_hl("FloatBorder", { fg = palette.darkgray })
  set_hl("EndOfBuffer", { fg = palette.darkgray })
  set_hl("FoldColumn", { fg = palette.gray })
  set_hl("VertSplit", { bg = nil, fg = palette.darkgray })
  set_hl("TabLineFill", { bg = nil })
  set_hl("DiagnosticError", { fg = palette.red })

  set_hl("IlluminatedWordText", { bg = palette.darkgray })
  set_hl("IlluminatedWordRead", { bg = palette.darkgray })
  set_hl("IlluminatedWordWrite", { bg = palette.darkgray })

  set_hl("Normal", { bg = "none" })
  set_hl("NormalFloat", { bg = "none" })
  set_hl("SignColumn", { bg = "none" })
  set_hl("LineNr", { bg = "none" })
  set_hl("CursorLineNr", { bg = "none" })
  set_hl("StatusLine", { bg = "none" })
  set_hl("StatusLineNC", { bg = "none" })
  set_hl("NonText", { bg = "none" })
  set_hl("Folded", { bg = "none" })
  
  -- Fix diff colors for better readability
  set_hl("DiffAdd", { fg = "#ffffff", bg = "#50a050" })
  set_hl("DiffChange", { fg = "#ffffff", bg = "#808020" })
  set_hl("DiffDelete", { fg = "#ffffff", bg = "#a05050" })
  set_hl("DiffText", { fg = "#ffffff", bg = "#a0a020" })
  
  -- Neogit specific highlight groups (aligned with habamax)
  set_hl("NeogitDiffAdd", { fg = "#bcbcbc", bg = "#2d3d2d" })
  set_hl("NeogitDiffDelete", { fg = "#bcbcbc", bg = "#3d2d2d" })
  set_hl("NeogitDiffContext", { fg = "#767676", bg = "none" })
  set_hl("NeogitDiffAddHighlight", { fg = "#ffffff", bg = "#3d4d3d" })
  set_hl("NeogitDiffDeleteHighlight", { fg = "#ffffff", bg = "#4d3d3d" })
  set_hl("NeogitDiffContextHighlight", { fg = "#bcbcbc", bg = "#262626" })
  set_hl("NeogitHunkHeader", { fg = "#af87af", bg = "#2a2a2a" })
  set_hl("NeogitHunkHeaderHighlight", { fg = "#ffffff", bg = "#3a3a3a" })
end

vim.api.nvim_create_autocmd("colorscheme", {
  callback = function()
    set_global_theme()
  end,
})

-- Options: habamax, lunaperche, retrobox, wildcharm, zaibatsu
vim.cmd.colorscheme("habamax")

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Apply theme overrides after everything is loaded
    set_global_theme()
  end
})
