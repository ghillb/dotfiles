local packer_opts = {
  "ellisonleao/glow.nvim",
  config = function()
    local ok, glow = pcall(require, "glow")
    if not ok then
      return
    end

    local config = {
      glow_install_path = "~/.local/bin", -- default path for installing glow binary
      border = "none", -- floating window border config
      style = "dark", -- filled automatically with your current editor background, you can override using glow json style
      pager = true,
    }
    glow.setup(config)
  end,
}
return packer_opts
