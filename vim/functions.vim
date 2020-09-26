autocmd InsertEnter,InsertLeave * set cul!

fun! FzfOmniFiles()
    let is_git = system('git status')
    if v:shell_error
        :Files
    else
        :GitFiles --exclude-standard
    endif
endfun

