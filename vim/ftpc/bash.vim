autocmd FileType sh call SetBashSettings()

fun! SetBashSettings()
    let b:ExecutorFunction = function('<SID>BashExecuter')
endfun

fun! s:BashExecuter(run_bin)
    exec '!' . a:run_bin shellescape(@%, 1)
endfun

