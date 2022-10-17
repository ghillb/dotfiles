local packer_opts = {
  "arthurxavierx/vim-caser",
  config = function()
    vim.g.caser_prefix = "gC"
  end,
}
return packer_opts
