local packer_opts = {
  "RRethy/vim-illuminate",
  disable = vim.env.NVIM_EMBEDDED == "true",
  config = function()
    local ok, illuminate = pcall(require, "illuminate")
    if not ok then
      return
    end

    local config = {
      providers = {
        "lsp",
        "treesitter",
        "regex",
      },
      delay = 100,
      filetypes_denylist = {
        "fugitive",
      },
      filetypes_allowlist = {},
      modes_denylist = {},
      modes_allowlist = {},
      providers_regex_syntax_denylist = {},
      providers_regex_syntax_allowlist = {},
      under_cursor = false,
    }
    illuminate.configure(config)
  end,
}
return packer_opts
