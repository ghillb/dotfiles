local packer_opts = {
  "metakirby5/codi.vim",
  disable = vim.env.NVIM_EMBEDDED == "true",
  config = function()
    vim.g["codi#virtual_text_prefix"] = "❯ "
    vim.g["codi#interpreters"] = { python = { bin = "python3" } }
  end,
}
return packer_opts
