if filereadable(expand($NVC) . '/localrc.vim') | source $NVC/localrc.vim | endif
au DirChanged * if filereadable(expand('%:p:h') . '/.exrc.vim') | source %:p:h/.exrc.vim | endif
au BufEnter * lua PopulateInfo()
au VimEnter * silent call SetRoot('start_dir')
au TextChanged,TextChangedI * if &readonly == 0 && filereadable(bufname('%')) | silent write | endif
au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=500}

fun! TmuxMove(direction)
  let wnr = winnr()
  silent! execute 'wincmd ' . a:direction
  " If the winnr is still the same after we moved, it is the last pane
  if wnr == winnr()
    call system('tmux select-pane -' . tr(a:direction, 'phjkl', 'lLDUR'))
  end
endfun

fun! ToggleGutter()
  if &scl == 'yes' | set scl=no | else | set scl=yes | endif
  set rnu! nu!
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

