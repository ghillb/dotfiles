if filereadable(expand($NVC) . '/localrc.vim') | source $NVC/localrc.vim | endif
au BufEnter * if filereadable(expand('%:p:h') . '/.exrc.vim') | source %:p:h/.exrc.vim | endif
au BufEnter * call SetGitModifiedCount() | call SetSelectiveFilename() | call SetSelectiveFiletype() | call SetCurrentGitBranch()
au VimEnter * call SetRoot('start_dir')
au TextChanged,TextChangedI * if &readonly == 0 && filereadable(bufname('%')) | silent write | endif

if has('nvim')
  au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=500}
  au TermEnter,TermOpen * setlocal nospell nobuflisted nonumber nornu
endif

fun! SetCurrentGitBranch()
  let l:branch_name = system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
  let g:current_git_branch = l:branch_name ==# '' ? '' : ' ' . l:branch_name
endfun

fun! SetGitModifiedCount()
  let l:modified_count = system('git diff --numstat | wc -l | tr -d "\n" ')
  let g:git_modified_count = l:modified_count =~ '\D' ? "" : l:modified_count
endfun

fun! SetSelectiveFilename()
  let g:selective_filename = &filetype =~# '\v^(neoterm|vimwiki)' ? expand('%:t') : ''
endfun

fun! SetSelectiveFiletype()
  let g:selective_filetype = &filetype =~# '\v^(neoterm)' ? '' : &filetype
endfun

fun! LinePercent()
    return line('.') * 100 / line('$') . '%%'
endfun

fun! TelescopeOmniFiles()
  if v:shell_error || system('git submodule status') != ""
    :Telescope find_files
  else
    :Telescope git_files
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
  if isdirectory($VIM_ROOT)
    chdir $VIM_ROOT
  else
    echo "directory doesn't exist"
  endif
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

fun! GetActiveBuffers()
  let l:blist = getbufinfo({'bufloaded': 1})
  let l:result = []
  for l:item in l:blist
    "skip unnamed buffers; also skip hidden buffers?
    if empty(l:item.name) || l:item.hidden
      continue
    endif
    call add(l:result, shellescape(l:item.name))
  endfor
  return l:result
endfun

fun! NewTerminalToggle()
  let l:blist = GetActiveBuffers()
  for buftitle in l:blist
    if buftitle =~? 'term://'
      :Ttoggle
      break
    endif
  endfor
  :Tnew
  execute "normal \<c-w>ji"
endfun

fun! CreateOrGoToFile()
  let l:node_path = expand(expand('<cfile>'))
  if ! (filereadable(l:node_path) || isdirectory(l:node_path))
    let choice = confirm("Create new file: " . l:node_path . "?", "&Yes\n&No", 1)
    if choice != 1
      return
    endif
  endif
  execute "vsplit " . l:node_path
endfun

