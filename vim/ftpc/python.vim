autocmd FileType python call SetPythonSettings()

fun! SetPythonSettings()
    map <buffer><m-r> :w<cr>:exec '!python3' shellescape(@%, 1)<cr>
    imap <buffer><m-r> <esc>:w<cr>:exec '!python3' shellescape(@%, 1)<cr>
endfun

