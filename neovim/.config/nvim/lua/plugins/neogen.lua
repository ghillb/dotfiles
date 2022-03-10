local packer_opts = {
  "danymat/neogen",
  config = function()
    require("neogen").setup({
      enabled = true,
    })
  end,
  requires = "nvim-treesitter/nvim-treesitter",
}
return packer_opts
