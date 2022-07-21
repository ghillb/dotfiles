local packer_opts = {
  "hrsh7th/vim-vsnip",
  disable = vim.env.NVIM_EMBEDDED == "true",
  config = function()
    vim.g.vsnip_filetypes = { bash = { "sh" } }
    vim.g.vsnip_snippet_dir = "~/code/scripts/snippets"

  end,
}
return packer_opts
