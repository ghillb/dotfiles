local packer_opts = {
  "RRethy/vim-illuminate",
  disable = vim.env.NVIM_EMBEDDED == "true",
  config = function ()
    vim.g.Illuminate_highlightUnderCursor = 0
    vim.g.Illuminate_delay = 100
  end
}
return packer_opts

