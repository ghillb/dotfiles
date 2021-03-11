if filereadable(expand($NVC) . '/localrc.vim') | source $NVC/localrc.vim | endif
au BufEnter * if filereadable(expand('%:p:h') . '/.exrc.vim') | source %:p:h/.exrc.vim | endif
au VimEnter * let $VIM_ROOT = getcwd()
au InsertEnter,InsertLeave * set cul!
au TextChanged,TextChangedI * if &readonly == 0 && filereadable(bufname('%')) | silent write | endif

if has('nvim')
    au TermOpen * setlocal nospell
    au TermEnter * setlocal nobuflisted
endif

fun! LightlineGit()
    let l:branch = fugitive#head()
    return l:branch ==# '' ? '' : ' ' . l:branch
endfun

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
    if v:shell_error || system('git submodule status') != ""
        :Files
    else
        :GitFiles --exclude-standard
    endif
endfun

fun! TmuxMove(direction)
        let wnr = winnr()
        silent! execute 'wincmd ' . a:direction
        " If the winnr is still the same after we moved, it is the last pane
        if wnr == winnr()
                call system('tmux select-pane -' . tr(a:direction, 'phjkl', 'lLDUR'))
        end
endfun

fun! ToggleFern()
  if (&ft=='fern')
    :Fern . -drawer -toggle
  else
    :FernDo :
    if (&ft!='fern')
      :Fern . -drawer -toggle -reveal=%
    endif
  endif 
endfun

fun! KittyCursor()
  let l:cursor_pos = system('echo $KITTY_PIPE_DATA | cut -d":" -f2')
  let l:y = split(l:cursor_pos,",")[1]
  let l:x = split(l:cursor_pos,",")[0] + 1
  call cursor(l:y,l:x)
endfun

