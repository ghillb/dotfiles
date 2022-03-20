local packer_opts = {
  "stevearc/qf_helper.nvim",
  config = function()
    local ok, qf_helper = pcall(require, 'qf_helper')
    if not ok then
      return
    end

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
