local ok, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if not ok then
  return
end

local config = {
  highlight = {
    enable = true,
    disable = {'vim'},
  },
  indent = {
    enable = true,
    disable = {},
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<a-v>",
      node_incremental = "<a-v>",
      node_decremental = "<a-s-v>",
      scope_incremental = "<a-b>",
    },
  },
}

treesitter_configs.setup(config)

local parser_configs = require 'nvim-treesitter.parsers'.get_parser_configs()
parser_configs.yaml.used_by =  'gitlab-ci'
parser_configs.yaml.used_by =  'ansible'

parser_configs.norg = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg",
        files = { "src/parser.c", "src/scanner.cc" },
        branch = "main"
    },
}

