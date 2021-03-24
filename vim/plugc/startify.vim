let g:startify_session_dir = $NVC .'/session'
let g:startify_custom_header = ''
let g:startify_change_to_vcs_root = 1
let g:startify_lists = [
    \ { 'header': ['   Files:'],                  'type': 'files' },
    \ { 'header': ['   CWD, '. getcwd(). ':'],    'type': 'dir' },
    \ { 'header': ['   Sessions:'],               'type': 'sessions' },
    \ { 'header': ['   Bookmarks:'],              'type': 'bookmarks' },
    \ { 'header': ['   Commands:'],               'type': 'commands' },
    \ ]

let g:startify_skiplist = [
       \ '/notes/.*',
       \ '^/tmp',
       \ '\.vimgolf',
       \ ]

au User StartifyBufferOpened let $VIM_ROOT = getcwd()

