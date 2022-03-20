local packer_opts = {
  "AckslD/nvim-neoclip.lua",
  config = function()
    local ok, neoclip = pcall(require, "neoclip")
    if not ok then
      return
    end

    local config = { default_register = { '"', "+", "*" } }
    neoclip.setup(config)
  end,
}
return packer_opts
