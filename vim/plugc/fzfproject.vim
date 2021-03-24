let g:fzfSwitchProjectWorkspaces = [ '~/code' ]
let g:fzfSwitchProjectProjects = [ '~/.files', '~/scripts' ]
let g:fzfSwitchProjectGitInitBehavior = 'ask'
let g:fzfSwitchProjectAlwaysChooseFile = 1
au User FzfSwitchProjectBufferEvent call SetRoot('git_dir')

