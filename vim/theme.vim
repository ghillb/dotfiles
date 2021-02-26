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
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'LightlineGit'
      \ },
      \ 'separator': {'left': "", 'right': ''},
      \ 'subseparator': { 'left': '', 'right': ''}
    \ }

hi Normal guibg=NONE ctermbg=NONE
let g:limelight_conceal_guifg = '#697A69'

