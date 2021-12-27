-- nvim highlight groups
vim.cmd([[ au colorscheme * hi Normal guibg=NONE ctermbg=NONE ]])
vim.cmd([[ au colorscheme * hi Terminal guibg=NONE ctermbg=NONE ]])
vim.cmd([[ au colorscheme * hi LineNr guibg=NONE ctermbg=NONE ]])
vim.cmd([[ au colorscheme * hi CursorLineNR guibg=NONE ctermbg=NONE ]])
vim.cmd([[ au colorscheme * hi SignColumn guibg=NONE ctermbg=NONE ]])
vim.cmd([[ au colorscheme * hi FoldColumn guibg=NONE ctermbg=NONE ]])
vim.cmd([[ au colorscheme * hi VertSplit guibg=NONE ctermbg=NONE ]])
vim.cmd([[ au colorscheme * hi Folded guibg=NONE ctermbg=NONE ]])
vim.cmd([[ au colorscheme * hi NonText guibg=NONE ctermbg=NONE ]])
vim.cmd([[ au colorscheme * hi SpecialKey guibg=NONE ctermbg=NONE ]])
vim.cmd([[ au colorscheme * hi NormalFloat guibg=NONE ctermbg=NONE ]])
vim.cmd([[ au colorscheme * hi MsgArea guibg=NONE ctermbg=NONE ]])
vim.cmd([[ au colorscheme * hi StatusLine guifg=#3c3836 ]])
vim.cmd([[ au colorscheme * hi EndOfBuffer guibg=NONE ctermbg=NONE guifg=#3c3836 ]])
vim.cmd([[ au colorscheme * hi NonText guibg=NONE ctermbg=NONE guifg=#3c3836 ]])
-- vim.cmd([[ au colorscheme * hi TabLine guibg=NONE ]])
vim.cmd([[ au colorscheme * hi TabLineSel guifg=#ebdbb2 ]])
vim.cmd([[ au colorscheme * hi TabLineFill guibg=NONE ctermbg=NONE ]])

-- plugin highlight groups
vim.cmd([[ au colorscheme * hi GitSignsAdd guibg=NONE ctermbg=NONE guifg=#989719 ]])
vim.cmd([[ au colorscheme * hi GitSignsChange guibg=NONE ctermbg=NONE guifg=#b16286 "#448488 ]])
vim.cmd([[ au colorscheme * hi GitSignsDelete guibg=NONE ctermbg=NONE guifg=#fb4934 ]])
vim.cmd([[ au colorscheme * hi NvimTreeNormal guibg=NONE ctermbg=NONE ]])
vim.cmd([[ au colorscheme * hi NvimTreeIndentMarker guifg=#3c3836 ]])

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

-- enable colorscheme
-- vim.cmd([[ silent! colorscheme kanagawa ]])
-- vim.cmd([[ silent! colorscheme gruvbit ]])
vim.cmd([[ silent! colorscheme gruvbox ]])
