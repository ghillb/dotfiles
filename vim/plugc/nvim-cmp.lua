local ok, cmp = pcall(require, 'cmp')
if not ok then
  return
end

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<c-d>'] = cmp.mapping.scroll_docs(4),
    ['<c-u>'] = cmp.mapping.scroll_docs(-4),
    ['<a-cr>'] = cmp.mapping.complete(),
    ['<c-e>'] = cmp.mapping.close(),
    ['<cr>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
  },
  documentation = {
    border = 'single'
  },
  preselect = cmp.PreselectMode.Item
})

