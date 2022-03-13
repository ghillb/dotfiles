local packer_opts = {
  "norcalli/nvim-colorizer.lua",
  config = function()
    if vim.env.NVIM_INIT then return end
    require("colorizer").setup()
  end,
}
return packer_opts
