" toggles cursor line in insert mode
autocmd InsertEnter,InsertLeave * set cul!

" run python files with M-r
autocmd FileType python map <buffer> <M-r> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <M-r> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

