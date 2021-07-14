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
au FileType fugitive no <buffer><silent> q :x<cr>
au FileType neoterm map <buffer> <tab> <nop>
au FileType rust map <a-s-t> :T cd %:p:h; cargo test --all-targets<cr>
au FileType java lua require('jdtls').start_or_attach({cmd = {'java-lsp.sh'}})
au FileType tf set ft=tf | set ft=hcl

aug quickfix
  au! *
  au FileType qf map <buffer> dd :call RemoveQFItem()<cr>
  au FileType qf map <buffer> <localleader>r :cdo s///
  au FileType qf map <buffer> <tab> <nop>
  au FileType qf map <buffer> <s-tab> <nop>
  au FileType qf map <buffer> <c-p> <c-w>k<c-p>
  au FileType qf map <buffer> <c-e> <c-w>k<c-e>
  au FileType qf map <buffer> <c-b> <c-w>k<c-b>
  au FileType qf map <buffer> <c-g> <c-w>k<c-g>
  au FileType qf map <buffer> <c-\> <c-w>k<c-\>
  au FileType qf map <buffer> <a-\> <c-w>k<a-\>
aug END
