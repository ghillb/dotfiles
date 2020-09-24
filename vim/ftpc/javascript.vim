autocmd FileType javascript call SetJavaScriptSettings()

fun! SetJavaScriptSettings()
    map <buffer><m-r> :w<cr>:exec '!node' shellescape(@%, 1)<cr>
    imap <buffer><m-r> <esc>:w<cr>:exec '!node' shellescape(@%, 1)<cr>
endfun
