vim.g.vsnip_filetypes = { bash = { "sh" } }
vim.g.vsnip_snippet_dir = "~/code/scripts/snippets"

-- vsnip mappings
vim.cmd([[

  imap <expr> <c-e>   vsnip#expandable()  ? '<plug>(vsnip-expand)'         : '<c-e>'
  smap <expr> <c-e>   vsnip#expandable()  ? '<plug>(vsnip-expand)'         : '<c-e>'
  imap <expr> <tab>   vsnip#jumpable(1)   ? '<plug>(vsnip-jump-next)'      : '<tab>'
  smap <expr> <tab>   vsnip#jumpable(1)   ? '<plug>(vsnip-jump-next)'      : '<tab>'
  imap <expr> <s-tab> vsnip#jumpable(-1)  ? '<plug>(vsnip-jump-prev)'      : '<s-Tab>'
  smap <expr> <s-tab> vsnip#jumpable(-1)  ? '<plug>(vsnip-jump-prev)'      : '<s-Tab>'

]])
