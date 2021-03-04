let g:fzf_checkout_git_options = '--sort=-committerdate'
let g:fzf_branch_actions = {
  \ 'delete': {'keymap': 'ctrl-x'},
  \ 'diff': {
  \   'prompt': 'Diff> ',
  \   'execute': 'Git diff {branch}',
  \   'multiple': v:false,
  \   'keymap': 'ctrl-f',
  \   'required': ['branch'],
  \   'confirm': v:false,
  \ },
  \}

