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
end

vim.api.nvim_create_autocmd("colorscheme", {
  callback = function()
    set_global_theme()
  end,
})

vim.cmd.colorscheme("default")

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd([[
      highlight Normal guibg=NONE ctermbg=NONE
      highlight NormalFloat guibg=NONE ctermbg=NONE
      highlight SignColumn guibg=NONE ctermbg=NONE
      highlight LineNr guibg=NONE ctermbg=NONE
      highlight CursorLineNr guibg=NONE ctermbg=NONE
      highlight StatusLine guibg=NONE ctermbg=NONE
      highlight StatusLineNC guibg=NONE ctermbg=NONE
      highlight EndOfBuffer guibg=NONE ctermbg=NONE
      highlight TabLineFill guibg=NONE ctermbg=NONE
      highlight NonText guibg=NONE ctermbg=NONE
      highlight VertSplit guibg=NONE ctermbg=NONE
      highlight Folded guibg=NONE ctermbg=NONE
      highlight FoldColumn guibg=NONE ctermbg=NONE
    ]])
  end
})