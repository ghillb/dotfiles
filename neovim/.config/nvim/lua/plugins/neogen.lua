local packer_opts = {
  "danymat/neogen",
  disable = vim.env.NVIM_EMBEDDED == "true",
  config = function()
    local ok, neogen = pcall(require, "neogen")
    if not ok then
      return
    end

    local config = {
      enabled = true,
    }

    neogen.setup(config)
  end,
  requires = "nvim-treesitter/nvim-treesitter",
}
return packer_opts
