local packer_opts = {
  "ray-x/lsp_signature.nvim",
  disable = vim.env.NVIM_EMBEDDED == "true",
  config = function()
    local ok, lsp_signature = pcall(require, "lsp_signature")
    if not ok then
      return
    end

    local config = {
      bind = true,
      doc_lines = 2,
      floating_window = true,
      fix_pos = false,
      hint_enable = true,
      hint_prefix = "-> ",
      hint_scheme = "String",
      use_lspsaga = false,
      hi_parameter = "IncSearch",
      max_height = 12,
      max_width = 120,
      handler_opts = {
        border = nil,
      },
      extra_trigger_chars = {},
    }

    lsp_signature.setup(config)
  end,
}
return packer_opts
