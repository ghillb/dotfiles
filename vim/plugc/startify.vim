let g:startify_session_dir = $NVC .'/session'
let g:startify_custom_header = ''
let g:startify_files_number = 8
let g:startify_change_to_vcs_root = 1
let g:startify_lists = [
    \ { 'header': ['   Files:'],                  'type': 'files' },
    \ { 'header': ['   CWD, '. getcwd(). ':'],    'type': 'dir' },
    \ { 'header': ['   Sessions:'],               'type': 'sessions' },
    \ { 'header': ['   Bookmarks:'],              'type': 'bookmarks' },
    \ { 'header': ['   Commands:'],               'type': 'commands' },
    \ ]

    let g:startify_commands = [
        \ {'p': ['Open Project', 'Telescope project']},
        \ {'u': ['Plugin update', 'PackerSync']},
        \ {'s': ['Plugin status', 'PackerStatus']},
        \ {'h': ['Vim Reference', 'h ref']},
        \ ]

let g:startify_skiplist = [
       \ '/notes/.*',
       \ '^/tmp',
       \ '\.vimgolf',
       \ ]

au User StartifyBufferOpened silent call SetRoot('git_dir')

