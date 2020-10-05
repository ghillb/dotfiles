autocmd FileType sh call SetBashSettings()

fun! SetBashSettings()
    let b:ExecutorFunction = function('<SID>BashExecuter')
endfun

fun! s:BashExecuter(run_bin)
    exec '!' . a:run_bin shellescape(@%, 1)
endfun

lua <<EOF
    local has_lsp, nvim_lsp = pcall(require, 'nvim_lsp')
    if has_lsp then
        nvim_lsp.bashls.setup{on_attach=require'completion'.on_attach}
    end
EOF

