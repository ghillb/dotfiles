let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse --bind ctrl-a:select-all'
let $FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git" '

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

