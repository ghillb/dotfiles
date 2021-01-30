autocmd FileType markdown call SetMarkdownSettings()

" custom surroundings for vim-surround
fun! SetMarkdownSettings()
    let b:surround_{char2nr('c')} = "```\r```"
    let b:surround_{char2nr('b')} = "**\r**"
endfun

