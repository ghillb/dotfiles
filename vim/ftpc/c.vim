autocmd FileType c* call SetCSettings()

fun! SetCSettings()
    echo 'SIC'
    let b:ExecutorFunction = function('<SID>CExecuter')
endfun

fun! s:CExecuter(run_bin)
    exec '!' . a:run_bin . ' -C %:p:h/'
    exec '!' . '%:r'
endfun

