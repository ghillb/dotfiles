autocmd FileType javascript call SetJavaScriptSettings()

fun! SetJavaScriptSettings()
    let b:ExecutorFunction = function('<SID>JavaScriptExecuter')
endfun

fun! s:JavaScriptExecuter(run_bin)
    exec '!' . a:run_bin shellescape(@%, 1)
endfun

