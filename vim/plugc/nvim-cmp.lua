local ok_cmp, cmp = pcall(require, 'cmp')
local ok_lspkind, lspkind = pcall(require, 'lspkind')
if not ok_cmp and ok_lspkind then
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
    { name = 'nvim_lua' },
    { name = 'vsnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
  documentation = {
    border = 'single'
  },
  formatting = {
    format = lspkind.cmp_format{
      menu = {
        buffer = "[buff]",
        path = "[path]",
        vsnip = "[snip]",
        nvim_lsp = "[lsp]",
        nvim_lua = "[nvim]",
      },
      with_text = false,
      maxwidth = 50
    }
  },
  experimental = {
    ghost_text = true,
    native_menu = false
  },
  preselect = cmp.PreselectMode.Item
})

