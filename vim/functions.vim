if filereadable(expand($NVC) . '/localrc.vim') | source $NVC/localrc.vim | endif

autocmd InsertEnter,InsertLeave * set cul!
autocmd BufEnter * if filereadable(expand('%:p:h') . '/.exrc') | source %:p:h/.exrc | endif
autocmd BufLeave * if exists("g:run_bin_local") | unlet g:run_bin_local | endif

function! Ticks(inner)
    normal! gv
    call searchpos('`', 'bW')
    if a:inner | exe "normal! 1\<space>" | endif
    normal! o
    call searchpos('`', 'W')
    if a:inner | exe "normal! \<bs>" | endif
endfunction

vnoremap <silent> a` :<c-u>call Ticks(0)<cr>
vnoremap <silent> i` :<c-u>call Ticks(1)<cr>
onoremap <silent> a` :<c-u>normal va`<cr>
onoremap <silent> i` :<c-u>normal vi`<cr>

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
                            \ 'python': 'python3',
                            \ 'javascript': 'node',
                            \ 'rust': 'rustc',
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

