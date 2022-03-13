local packer_opts = {
  "danymat/neogen",
  config = function()
    if vim.env.NVIM_INIT then return end
    require("neogen").setup({
      enabled = true,
    })
  end,
  requires = "nvim-treesitter/nvim-treesitter",
}
return packer_opts
