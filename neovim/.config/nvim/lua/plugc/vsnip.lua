vim.g.vsnip_filetypes = { bash = { "sh" } }

vim.g.vsnip_snippet_dir = vim.fn.expand(vim.env.CODE .. "/scripts/snippets")
vim.g.vsnip_snippet_dirs = {
  vim.fn.expand(vim.env.DOTFILES .. "/snippets"),
  vim.fn.expand(vim.env.CODE .. "/scripts/snippets"),
}
