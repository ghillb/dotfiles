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
hi GitGutterAdd guibg=NONE ctermbg=NONE guifg=#689d6a
hi GitGutterChange guibg=NONE ctermbg=NONE guifg=#458588
hi GitGutterDelete guibg=NONE ctermbg=NONE guifg=#fb4934
hi GitGutterChangeDelete guibg=NONE ctermbg=NONE guifg=#fb4934

if !empty($SSH_TTY)
  let g:currentmode={    
    \ 'n'  : 'NORMAL ',    
    \ 'v'  : 'VISUAL ',    
    \ 'V'  : 'V·LINE ',    
    \ "\<C-V>" : 'V·BLOCK ',    
    \ 'i'  : 'INSERT ',    
    \ 't'  : 'TERMINAL ',    
    \ 'R'  : 'REPLACE ',    
    \ 'Rv' : 'V·REPLACE ',    
    \ 'c'  : 'COMMAND ',    
    \}    
       
  set statusline=    
  set statusline+=\ %{g:currentmode[mode()]}    
  set statusline+=%#LineNr#    
  set statusline+=\ %{g:current_git_branch}    
  set statusline+=\ %t
  set statusline+=%m    
  set statusline+=%=    
  set statusline+=%#CursorColumn#    
  set statusline+=\ %{&fileencoding?&fileencoding:&encoding}    
  set statusline+=\ %y    
  set statusline+=\ %p%%    
  set statusline+=\ %l:%c
endif
