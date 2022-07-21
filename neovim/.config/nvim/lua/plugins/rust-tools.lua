local packer_opts = {
  disable = vim.env.NVIM_EMBEDDED == "true",
  "simrat39/rust-tools.nvim",
  requires = { "neovim/nvim-lspconfig" },
}
return packer_opts
