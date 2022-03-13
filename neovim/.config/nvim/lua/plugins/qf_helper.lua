local packer_opts = {
  "stevearc/qf_helper.nvim",
  config = function()
    if vim.env.NVIM_INIT then return end
    local qf_helper = require("qf_helper")

    local config = {
      prefer_loclist = true,
      sort_lsp_diagnostics = true,
      quickfix = {
        autoclose = true,
        default_bindings = true,
        default_options = true,
        max_height = 10,
        min_height = 1,
        track_location = "cursor",
      },
      loclist = {
        autoclose = true,
        default_bindings = true,
        default_options = true,
        max_height = 10,
        min_height = 1,
        track_location = "cursor",
      },
    }

    qf_helper.setup(config)
  end,
}
return packer_opts
