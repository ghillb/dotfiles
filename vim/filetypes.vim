au FileType sh call SetBashSettings()
fun! SetBashSettings()
  let b:ExecutorFunction = function('<SID>BashExecuter')
endfun

fun! s:BashExecuter(run_bin)
  exec '!' . a:run_bin shellescape(@%, 1)
endfun

au FileType python call SetPythonSettings()
fun! SetPythonSettings()
  let b:ExecutorFunction = function('<SID>PythonExecuter')
endfun

fun! s:PythonExecuter(run_bin)
  exec '!' . a:run_bin shellescape(@%, 1)
endfun

au FileType rust call SetRustSettings()
fun! SetRustSettings()
  let b:ExecutorFunction = function('<SID>RustExecuter')
endfun

fun! s:RustExecuter(run_bin)
  exec '!' . a:run_bin shellescape(@%, 1) '-o %:r'
  exec '!' . '%:r'
endfun

au FileType jl call SetPythonSettings()
fun! SetJuliaSettings()
  let b:ExecutorFunction = function('<SID>JuliaExecuter')
endfun

fun! s:JuliaExecuter(run_bin)
  exec '!' . a:run_bin shellescape(@%, 1)
endfun

au FileType javascript call SetJavaScriptSettings()
fun! SetJavaScriptSettings()
  let b:ExecutorFunction = function('<SID>JavaScriptExecuter')
endfun

fun! s:JavaScriptExecuter(run_bin)
  exec '!' . a:run_bin shellescape(@%, 1)
endfun

au FileType go call SetGoSettings()
fun! SetGoSettings()
  let b:ExecutorFunction = function('<SID>GoExecuter')
endfun

fun! s:GoExecuter(run_bin)
  exec '!' . a:run_bin . ' run ' . shellescape(@%, 1)
endfun

au FileType c* call SetCSettings()
fun! SetCSettings()
  let b:ExecutorFunction = function('<SID>CExecuter')
endfun

fun! s:CExecuter(run_bin)
  exec '!' . a:run_bin . ' -C %:p:h/'
  exec '!' . '%:r'
endfun

au FileType markdown call SetMarkdownSettings()
" custom surroundings for vim-surround
fun! SetMarkdownSettings()
  let b:surround_{char2nr('c')} = "```\r```"
  let b:surround_{char2nr('b')} = "**\r**"
endfun

au FileType git normal zR
au FileType fugitive no <buffer><silent> q :x<cr>

