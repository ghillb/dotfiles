au VimEnter * if filereadable(expand($NVC) . '/localrc.vim') | source $NVC/localrc.vim | endif
au BufEnter * if filereadable(expand('%:p:h') . '/.exrc.vim') | source %:p:h/.exrc | endif
au BufLeave * if exists("g:run_bin_local") | unlet g:run_bin_local | endif
au InsertEnter,InsertLeave * set cul!
au TextChanged,TextChangedI *.sh, *.yml silent write

if has('nvim')
    au TermOpen * setlocal nospell
endif

fun! Ticks(inner)
    normal! gv
    call searchpos('`', 'bW')
    if a:inner | exe "normal! 1\<space>" | endif
    normal! o
    call searchpos('`', 'W')
    if a:inner | exe "normal! \<bs>" | endif
endfun

fun! FzfOmniFiles()
    let is_git = system('git status')
    if v:shell_error
        :Files
    else
        :GitFiles --exclude-standard
    endif
endfun

fun! RunCode()
    let l:current_ft = &filetype
    let l:run_bin = get({
                            \ 'sh': 'bash',
                            \ 'python': 'python3',
                            \ 'javascript': 'node',
                            \ 'rust': 'cargo run',
                            \ 'c': 'make',
                            \ 'cpp': 'make',
                            \ 'go': 'go'
                        \}, current_ft, '')

    if run_bin == ''
        echo 'Filetype not supported: ' . current_ft
    else
        if exists("g:run_bin_local") | let l:run_bin = g:run_bin_local | endif
        call b:ExecutorFunction(run_bin)
    endif
endfun

