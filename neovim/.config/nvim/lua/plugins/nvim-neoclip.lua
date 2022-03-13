local packer_opts = {
  "AckslD/nvim-neoclip.lua",
  config = function()
    if vim.env.NVIM_INIT then return end
    require("neoclip").setup({ default_register = { '"', "+", "*" } })
  end,
}
return packer_opts
