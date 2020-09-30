autocmd FileType rust call SetRustSettings()

fun! SetRustSettings()
    let b:ExecutorFunction = function('<SID>RustExecuter')
endfun

fun! s:RustExecuter(run_bin)
    exec '!' . a:run_bin shellescape(@%, 1) '-o %:r'
    exec '!' . '%:r'
endfun

