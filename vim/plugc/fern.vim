fun! s:init_fern() abort
    nmap <buffer> s <Plug>(fern-action-open:split)
    nmap <buffer> v <Plug>(fern-action-open:vsplit)
    nmap <buffer> r <Plug>(fern-action-rename)
    nmap <buffer> m <Plug>(fern-action-move)
    nmap <buffer> c <Plug>(fern-action-copy)
    nmap <buffer> n <Plug>(fern-action-new-path)
    nmap <buffer> f <Plug>(fern-action-new-file)
    nmap <buffer> d <Plug>(fern-action-new-dir)
    nmap <buffer> x <Plug>(fern-action-remove)
    nmap <buffer> q :<c-u>quit<cr>
    nmap <buffer> .. <Plug>(fern-action-hidden-toggle)
    nmap <buffer> <space> <Plug>(fern-action-mark)
    nmap <silent><buffer> <cr> <Plug>(fern-action-open)<esc>:FernDo close<CR>
    nmap <silent><buffer> <a-esc> <c-w>l:Ttoggle<cr><c-w>ja
    nmap <buffer> <c-e> <nop>
    nmap <buffer> <c-p> <nop>
    nmap <buffer> <c-b> <nop>
    nmap <buffer> <c-g> <nop>
    nmap <buffer> <c-\> <nop>
endfun

aug fern-custom
    au! *
    au FileType fern setlocal nospell nonumber norelativenumber
    au FileType fern call s:init_fern()
aug END

let g:fern#default_hidden = 1
let g:fern#default_exclude = '^\%(\.git\|\.idea\)$'

