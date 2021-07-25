if has('termguicolors') && has('nvim') | set termguicolors | endif
if has('nvim') | set fcs=eob:· | endif

let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection = '0'

silent! colorscheme gruvbox

hi Normal guibg=NONE ctermbg=NONE
hi Terminal guibg=NONE ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
hi CursorLineNR guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi FoldColumn guibg=NONE ctermbg=NONE
hi VertSplit guibg=NONE ctermbg=NONE
hi Folded guibg=NONE ctermbg=NONE
hi NonText guibg=NONE ctermbg=NONE guifg=#83a598
hi SpecialKey guibg=NONE ctermbg=NONE
hi EndOfBuffer guibg=NONE ctermbg=NONE guifg=#504945
hi WarningMsg guibg=NONE ctermbg=NONE guifg=#fb4934
hi LspDiagnosticsDefaultError guifg=#fb4934
hi GitSignsAdd guibg=NONE ctermbg=NONE guifg=#989719 "#b16286
hi GitSignsChange guibg=NONE ctermbg=NONE guifg=#448488
hi GitSignsDelete guibg=NONE ctermbg=NONE guifg=#fb4934
hi StatusLine guifg=#3c3836

