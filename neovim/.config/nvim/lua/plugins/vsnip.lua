local packer_opts = {
  "hrsh7th/vim-vsnip",
  config = function()
    vim.g.vsnip_filetypes = { bash = { "sh" } }
    vim.g.vsnip_snippet_dir = "~/code/scripts/snippets"

  end,
}
return packer_opts
