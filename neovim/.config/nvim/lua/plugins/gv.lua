vim.cmd([[
function! s:scroll_commits(down) abort
  wincmd p
  execute 'normal!' a:down ? "\<c-e>" : "\<c-y>"
  wincmd p
endfunction

function! s:init_gv() abort
  nnoremap <silent> <buffer> J :call <sid>scroll_commits(1)<cr>
  nnoremap <silent> <buffer> K :call <sid>scroll_commits(0)<cr>
  nnoremap go :wincmd p<cr>:normal! zR<cr>:wincmd p<cr>
endfunction

augroup GVextras
  autocmd!
  autocmd FileType GV call s:init_gv()
augroup END
]])


