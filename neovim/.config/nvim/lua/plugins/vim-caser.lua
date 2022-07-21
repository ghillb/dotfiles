local packer_opts = {
  "arthurxavierx/vim-caser",
  disable = vim.env.NVIM_EMBEDDED == "true",
  config = function()
    vim.g.caser_prefix = "gC"
  end,
}
return packer_opts
