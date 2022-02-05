vim.g.vsnip_filetypes = { bash = { "sh" } }
vim.g.vsnip_snippet_dir = "~/code/scripts/snippets"

local map = vim.keymap.set

map({ "i", "s" }, "<tab>", function()
  return vim.fn["vsnip#jumpable"](1) == 1 and "<plug>(vsnip-jump-next)" or "<tab>"
end, { expr = true, remap = true })

map({ "i", "s" }, "<s-tab>", function()
  return vim.fn["vsnip#jumpable"](-1) == 1 and "<plug>(vsnip-jump-prev)" or "<s-tab>"
end, { expr = true, remap = true })
