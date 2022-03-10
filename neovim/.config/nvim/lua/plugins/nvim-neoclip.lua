local packer_opts = {
  "AckslD/nvim-neoclip.lua",
  config = function()
    require("neoclip").setup({ default_register = { '"', "+", "*" } })
  end,
}
return packer_opts
