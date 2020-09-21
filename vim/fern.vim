function! s:init_fern() abort
  nmap <buffer> - <Plug>(fern-action-open:split)
  nmap <buffer> \ <Plug>(fern-action-open:vsplit)
  nmap <buffer> r <Plug>(fern-action-rename)
  nmap <buffer> m <Plug>(fern-action-move)
  nmap <buffer> c <Plug>(fern-action-copy)
  nmap <buffer> n <Plug>(fern-action-new-path)
  nmap <buffer> f <Plug>(fern-action-new-file)
  nmap <buffer> d <Plug>(fern-action-new-dir)
  nmap <buffer> s <Plug>(fern-action-hidden-toggle)
  nmap <buffer> x <Plug>(fern-action-remove)
  nmap <buffer> <space> <Plug>(fern-action-mark)
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
  autocmd BufEnter * ++nested call s:hijack_directory()
augroup END

function! s:hijack_directory() abort
  let path = expand('%:p')
  if !isdirectory(path)
    return
  endif
  bwipeout %
  execute printf('Fern %s', fnameescape(path))
endfunction
