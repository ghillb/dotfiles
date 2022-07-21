local packer_opts = {
  "kenn7/vim-arsync",
  disable = vim.env.NVIM_EMBEDDED == "true",
}
return packer_opts
