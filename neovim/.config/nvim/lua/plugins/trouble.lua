local packer_opts = {
  "folke/trouble.nvim",
  requires = { "kyazdani42/nvim-web-devicons" },
  config = function()
    if vim.env.NVIM_INIT then return end
    local trouble = require("trouble")

    local config = {
      use_diagnostic_signs = true,
      icons = false,
    }

    trouble.setup(config)
  end,
}
return packer_opts
