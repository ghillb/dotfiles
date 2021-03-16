au FileType markdown call SetMarkdownSettings()
" custom surroundings for vim-surround
fun! SetMarkdownSettings()
  set spell
  let b:surround_{char2nr('c')} = "```\r```"
  let b:surround_{char2nr('b')} = "**\r**"
endfun

au FileType git normal zR
au FileType fugitive no <buffer><silent> q :x<cr>

aug quickfix
  au! *
  au FileType qf map <buffer> dd :call RemoveQFItem()<cr>
  au FileType qf map <buffer> <localleader>r :cdo s///
  au FileType qf map <buffer> <tab> <nop>
  au FileType qf map <buffer> <s-tab> <nop>
  au FileType qf map <buffer> <c-p> <c-w>k<c-p>
  au FileType qf map <buffer> <c-e> <c-w>k<c-e>
  au FileType qf map <buffer> <c-b> <c-w>k<c-b>
  au FileType qf map <buffer> <c-\> <c-w>k<c-\>
  au FileType qf map <buffer> <a-\> <c-w>k<a-\>
aug END
