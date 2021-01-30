imap <expr> <c-e>   vsnip#expandable()  ? '<plug>(vsnip-expand)'         : '<c-e>'
smap <expr> <c-e>   vsnip#expandable()  ? '<plug>(vsnip-expand)'         : '<c-e>'

imap <expr> <c-l>   vsnip#available(1)  ? '<plug>(vsnip-expand-or-jump)' : '<c-l>'
smap <expr> <c-l>   vsnip#available(1)  ? '<plug>(vsnip-expand-or-jump)' : '<c-l>'

imap <expr> <tab>   vsnip#jumpable(1)   ? '<plug>(vsnip-jump-next)'      : '<tab>'
smap <expr> <tab>   vsnip#jumpable(1)   ? '<plug>(vsnip-jump-next)'      : '<tab>'
imap <expr> <s-tab> vsnip#jumpable(-1)  ? '<plug>(vsnip-jump-prev)'      : '<s-Tab>'
smap <expr> <s-tab> vsnip#jumpable(-1)  ? '<plug>(vsnip-jump-prev)'      : '<s-Tab>'

let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['typescript']
let g:vsnip_filetypes.bash = ['sh']

let g:vsnip_snippet_dir = expand("~/scripts/snippets")
let g:vsnip_snippet_dirs = [$VC . "/snippets", expand("~/scripts/snippets")]

