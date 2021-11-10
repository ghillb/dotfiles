au FileType markdown call SetMarkdownSettings()
" custom surroundings for vim-surround
fun! SetMarkdownSettings()
  set spell
  set formatoptions-=tc
  let b:surround_{char2nr('c')} = "```\n\r\n```"
  let b:surround_{char2nr('i')} = "*\r*"
  let b:surround_{char2nr('b')} = "**\r**"
endfun

au FileType git normal zR
au FileType neoterm map <buffer> <tab> <nop>
au FileType yaml setlocal indentkeys-=<:>

aug quickfix
  au! *
  au FileType qf map <buffer> dd :call RemoveQFItem()<cr>
  au FileType qf map <buffer> <localleader>r :cdo s///
  au FileType qf map <buffer> <c-p> <nop>
  au FileType qf map <buffer> <c-e> <nop>
  au FileType qf map <buffer> <c-b> <nop>
  au FileType qf map <buffer> <c-g> <nop>
  au FileType qf map <buffer> <c-\> <nop>
aug END

aug NvimTree
  au! *
  au FileType NvimTree map <buffer> <c-p> <nop>
  au FileType NvimTree map <buffer> <c-e> <nop>
  au FileType NvimTree map <buffer> <c-b> <nop>
  au FileType NvimTree map <buffer> <c-g> <nop>
  au FileType NvimTree map <buffer> <c-\> <nop>
  au FileType NvimTree nn <buffer> <a-esc> <c-w>l
  au FileType NvimTree nn <silent><buffer> <a-q> :NvimTreeClose<cr>
aug END
