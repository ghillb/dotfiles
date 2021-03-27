if filereadable(expand($NVC) . '/localrc.vim') | source $NVC/localrc.vim | endif
au BufEnter * if filereadable(expand('%:p:h') . '/.exrc.vim') | source %:p:h/.exrc.vim | endif
au VimEnter * call SetRoot('start_dir')
au InsertEnter,InsertLeave * set cul!
au TextChanged,TextChangedI * if &readonly == 0 && filereadable(bufname('%')) | silent write | endif

if has('nvim')
  au TermOpen * setlocal nospell
  au TermEnter * setlocal nobuflisted
endif

fun! LightlineGitBranch()
  let l:branch = fugitive#head()
  return l:branch ==# '' ? '' : ' ' . l:branch
endfun

fun! LightlineGitModified()
  let l:modified_count = system('git diff --numstat | wc -l | tr -d "\n" ')
  return l:modified_count =~ '\D' ? "" : l:modified_count
endfun

fun! LightlineFilePath()
    return expand('%')
endfun

fun! OpenFzfCheckout()
  :chdir %:p:h
  :GBranches
  :chdir $VIM_ROOT
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

fun! SetRoot(new_root)
  let $VIM_ROOT = getcwd()
  if (a:new_root == 'git_root') 
    if fugitive#head() != ''
      let $VIM_ROOT = fugitive#repo().tree()
    else 
      echo "not a git repo"
      return
    endif
  endif
  if (a:new_root == 'parent_dir')
    let $VIM_ROOT = fnamemodify($VIM_ROOT, ':h')
  endif
  if (a:new_root == 'current_dir')
    let $VIM_ROOT = expand('%:p:h')
  endif
  if (a:new_root == 'start_dir') && len(argv()) > 0
    let $VIM_ROOT = fnamemodify(argv()[0], ':p:h')
  endif
  echo "rooted " . substitute(a:new_root, "_", " ", "") . ": " . $VIM_ROOT
  chdir $VIM_ROOT
endfun

fun! KittyCursor()
  let l:cursor_pos = system('echo $KITTY_PIPE_DATA | cut -d":" -f2')
  let l:y = split(l:cursor_pos,",")[1]
  let l:x = split(l:cursor_pos,",")[0] + 1
  call cursor(l:y,l:x)
endfun

fun! RemoveQFItem()
  let cur_qf_idx = line('.') -  1
  let qf_win_info = getwininfo(win_getid())[0]
  if qf_win_info['loclist'] == 1
    let loclist_win_nr = qf_win_info['winnr']
    let loclist_all = getloclist(loclist_win_nr)
    let cur_pos = getcurpos()
    call remove(loclist_all, cur_qf_idx)
    call setloclist(loclist_win_nr, loclist_all, 'r')
    execute cur_pos[1] . "lfirst"
    :lopen
  else
    let qf_all = getqflist()
    call remove(qf_all, cur_qf_idx)
    call setqflist(qf_all, 'r')
    execute cur_qf_idx + 1 . "cfirst"
    :copen
  endif
endfun

