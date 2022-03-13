local packer_opts = {
  "ray-x/lsp_signature.nvim",
  config = function()
    if vim.env.NVIM_INIT then return end
    local lsp_signature = require("lsp_signature")

    local config = {
      bind = true,
      doc_lines = 2,
      floating_window = true,
      fix_pos = false,
      hint_enable = true,
      hint_prefix = "-> ",
      hint_scheme = "String",
      use_lspsaga = false,
      hi_parameter = "Search",
      max_height = 12,
      max_width = 120,
      handler_opts = {
        border = "single",
      },
      extra_trigger_chars = {},
    }

    lsp_signature.setup(config)
  end,
}
return packer_opts
