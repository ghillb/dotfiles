local packer_opts = {
  "rcarriga/vim-ultest",
  requires = { "vim-test/vim-test" },
  run = ":UpdateRemotePlugins",
}
return packer_opts
