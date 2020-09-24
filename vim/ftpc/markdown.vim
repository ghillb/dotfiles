autocmd FileType markdown call SetMarkdownSettings()

fun! SetMarkdownSettings()
    let b:surround_{char2nr('c')} = "```\r```"
    let b:surround_{char2nr('b')} = "**\r**"
endfun

