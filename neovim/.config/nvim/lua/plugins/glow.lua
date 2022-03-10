local packer_opts = {
  "ellisonleao/glow.nvim",
  config = function()
    vim.g.glow_border = "single"
    vim.g.glow_use_pager = true
    vim.g.glow_style = "dark"
  end,
}
return packer_opts
