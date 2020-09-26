let $JSENV = '!node'
autocmd FileType javascript call SetJavaScriptSettings()

fun! SetJavaScriptSettings()
    map <buffer><m-r> :w<cr>:exec $JSENV shellescape(@%, 1)<cr>
    imap <buffer><m-r> <esc>:w<cr>:exec $JSENV shellescape(@%, 1)<cr>
endfun
