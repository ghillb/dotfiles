return {
  "RRethy/vim-illuminate",
  lazy = false,
  config = function()
    local illuminate = require("illuminate")

    illuminate.configure({
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
    })
  end,
}
