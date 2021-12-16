vim.g.asyncrun_open = 10
vim.g.asynctasks_term_reuse = 1
vim.g.asynctasks_term_focus = 0
vim.g.asynctasks_term_pos = "right"
vim.g.asynctasks_extra_config = { "~/.files/vim/tasks.ini" }

vim.cmd([[
  let g:asyncrun_runner = get(g:, 'asyncrun_runner', {})

  function! s:errmsg(msg)
    redraw
    echohl ErrorMsg
    echom 'ERROR: ' . a:msg
    echohl NONE
    return 0
  endfunction

  function! s:kitty_run(opts)
    if !executable('kitty')
      return s:errmsg('Kitty executable not found!')
    endif
    let cmds = []
    let cmds += ['cd ' . shellescape(getcwd()) ]
    let cmds += [a:opts.cmd]
    let cmds += ['echo ""']
    let cmds += ['read -n1 -rsp "Press any key to continue ..."']
    let text = shellescape(join(cmds, ";"))
    call system('kitty @ --to unix:/tmp/kitty-float close-window --match title:»_task')
    let command = 'kitty @ --to unix:/tmp/kitty-float launch --type=tab --title »_task --location after --keep-focus bash -c ' . text
    call system(command . ' &')
  endfunction

  let g:asyncrun_runner.kitty = function('s:kitty_run')

]])
