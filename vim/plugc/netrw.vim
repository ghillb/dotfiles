if !empty(glob($NVC . '/pack/minpac/start/fern.vim'))
    " disable netrw
    let g:loaded_netrw  = 1
    let g:loaded_netrwPlugin = 1
    let g:loaded_netrwSettings = 1
    let g:loaded_netrwFileHandlers = 1
else
    let g:netrw_banner = 0
    let g:netrw_liststyle = 3
    let g:netrw_browse_split = 4
    let g:netrw_winsize = 25
    let g:netrw_altv=1
endif

