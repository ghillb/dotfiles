vim.g.vsnip_filetypes = { bash = { "sh" } }

vim.g.vsnip_snippet_dir = vim.fn.expand("~/code/scripts/snippets")
vim.g.vsnip_snippet_dirs = { vim.env.VC .. "/snippets", vim.fn.expand("~/code/scripts/snippets") }
