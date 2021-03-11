let g:fzf_checkout_git_options = '--sort=-committerdate'
let g:fzf_branch_actions = {
  \ 'delete': {'keymap': 'ctrl-x'},
  \ 'create': {'create': 'ctrl-b'},
  \ 'rebase': {'rebase': 'ctrl-r'},
  \ 'merge': {'merge': 'ctrl-m'},
  \ 'checkout': {'keymap': 'enter'},
  \ 'track': {'keymap': 'alt-enter'},
  \ 'diff': {
  \   'prompt': 'Diff> ',
  \   'execute': 'Git diff {branch}',
  \   'multiple': v:false,
  \   'keymap': 'ctrl-f',
  \   'required': ['branch'],
  \   'confirm': v:false,
  \ },
  \}

