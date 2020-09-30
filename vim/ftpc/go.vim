autocmd FileType go call SetGoSettings()

fun! SetGoSettings()
    let b:ExecutorFunction = function('<SID>GoExecuter')
endfun

fun! s:GoExecuter(run_bin)
    exec '!' . a:run_bin . ' run ' . shellescape(@%, 1)
endfun

