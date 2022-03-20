local packer_opts = {
  "norcalli/nvim-colorizer.lua",
  config = function()
    local ok, colorizer = pcall(require, 'colorizer')
    if not ok then
      return
    end

    colorizer.setup()
  end,
}
return packer_opts
