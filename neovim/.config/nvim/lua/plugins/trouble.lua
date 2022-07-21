local packer_opts = {
  "folke/trouble.nvim",
  disable = vim.env.NVIM_EMBEDDED == "true",
  requires = { "kyazdani42/nvim-web-devicons" },
  config = function()
    local ok, trouble = pcall(require, 'trouble')
    if not ok then
      return
    end

    local config = {
      use_diagnostic_signs = true,
      icons = false,
    }

    trouble.setup(config)
  end,
}
return packer_opts
