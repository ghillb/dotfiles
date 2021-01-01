autocmd FileType jl call SetPythonSettings()

fun! SetJuliaSettings()
    let b:ExecutorFunction = function('<SID>JuliaExecuter')
endfun

fun! s:JuliaExecuter(run_bin)
    exec '!' . a:run_bin shellescape(@%, 1)
endfun

