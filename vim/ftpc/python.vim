autocmd FileType python call SetPythonSettings()

fun! SetPythonSettings()
    let b:ExecutorFunction = function('<SID>PythonExecuter')
endfun

fun! s:PythonExecuter(run_bin)
    exec '!' . a:run_bin shellescape(@%, 1)
endfun

