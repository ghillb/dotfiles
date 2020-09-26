let $PYENV = '!python3'
autocmd FileType python call SetPythonSettings()

fun! SetPythonSettings()
    map <buffer><m-r> :w<cr>:exec $PYENV shellescape(@%, 1)<cr>
    imap <buffer><m-r> <esc>:w<cr>:exec $PYENV shellescape(@%, 1)<cr>
endfun

