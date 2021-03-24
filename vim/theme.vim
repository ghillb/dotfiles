if has('termguicolors') | set termguicolors | endif

let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection = '1'

silent! colorscheme gruvbox

let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'mode_map': {
        \ 'n' : 'N',
        \ 'i' : 'I',
        \ 'R' : 'R',
        \ 'v' : 'V',
        \ 'V' : 'VL',
        \ "\<C-v>": 'VB',
        \ 'c' : 'C',
        \ 's' : 'S',
        \ 'S' : 'SL',
        \ "\<C-s>": 'SB',
        \ 't': 'T',
      \ },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'gitdiffcount', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'LightlineGitBranch'
      \ },
      \ 'component_expand': {
      \   'gitdiffcount': 'LightlineGitModified',
      \ },
      \ 'separator': {'left': "", 'right': ''},
      \ 'subseparator': { 'left': '', 'right': ''}
    \ }

hi Normal guibg=NONE ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
hi CursorLineNR guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi VertSplit guibg=NONE ctermbg=NONE
hi WarningMsg guibg=NONE ctermbg=NONE guifg=#fb4934
hi GitGutterAdd guibg=NONE ctermbg=NONE guifg=#689d6a
hi GitGutterChange guibg=NONE ctermbg=NONE guifg=#458588
hi GitGutterDelete guibg=NONE ctermbg=NONE guifg=#fb4934
hi GitGutterChangeDelete guibg=NONE ctermbg=NONE guifg=#fb4934

