local packer_opts = {
  "metakirby5/codi.vim",
  config = function()
    if vim.env.NVIM_INIT then return end
    vim.g["codi#virtual_text_prefix"] = "❯ "
    vim.g["codi#interpreters"] = { python = { bin = "python3" } }
  end,
}
return packer_opts
