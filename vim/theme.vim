if has('termguicolors') && has('nvim') | set termguicolors | endif
if has('nvim') | set fcs=eob:· | endif

au colorscheme * hi Normal guibg=NONE ctermbg=NONE
au colorscheme * hi Terminal guibg=NONE ctermbg=NONE
au colorscheme * hi LineNr guibg=NONE ctermbg=NONE
au colorscheme * hi CursorLineNR guibg=NONE ctermbg=NONE
au colorscheme * hi SignColumn guibg=NONE ctermbg=NONE
au colorscheme * hi FoldColumn guibg=NONE ctermbg=NONE
au colorscheme * hi VertSplit guibg=NONE ctermbg=NONE
au colorscheme * hi Folded guibg=NONE ctermbg=NONE
au colorscheme * hi NonText guibg=NONE ctermbg=NONE guifg=#83a598
au colorscheme * hi SpecialKey guibg=NONE ctermbg=NONE
au colorscheme * hi StatusLine guifg=#3c3836
au colorscheme * hi EndOfBuffer guibg=NONE ctermbg=NONE guifg=#504945
au colorscheme * hi WarningMsg guibg=NONE ctermbg=NONE guifg=#fb4934
au colorscheme * hi LspDiagnosticsDefaultError guifg=#fb4934
au colorscheme * hi GitSignsAdd guibg=NONE ctermbg=NONE guifg=#989719 "#b16286
au colorscheme * hi GitSignsChange guibg=NONE ctermbg=NONE guifg=#448488
au colorscheme * hi GitSignsDelete guibg=NONE ctermbg=NONE guifg=#fb4934
au colorscheme * hi NvimTreeIndentMarker guifg=#504945
au colorscheme * hi NormalFloat guibg=NONE ctermbg=NONE

let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection = '0'

silent! colorscheme gruvbox

