local packer_opts = {
  "nvim-treesitter/nvim-treesitter",
  config = function()
    local ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
    if not ok then
      return
    end

    local config = {
      highlight = {
        enable = true,
        disable = { "vim" },
      },
      indent = {
        enable = true,
        disable = { "yaml" },
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
      rainbow = {
        enable = false,
        disable = {},
        extended_mode = true,
        max_file_lines = nil,
      },
    }

    treesitter_configs.setup(config)

    local parsers = require("nvim-treesitter.parsers")
    parsers.filetype_to_parsername["ansible.yaml"] = "yaml"
    parsers.filetype_to_parsername["kubernetes.yaml"] = "yaml"
    parsers.filetype_to_parsername["docker-compose.yaml"] = "yaml"
    parsers.filetype_to_parsername["gitlab-ci.yaml"] = "yaml"

    parsers.get_parser_configs().norg = {
      install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg",
        files = { "src/parser.c", "src/scanner.cc" },
        branch = "main",
      },
    }
  end,
}
return packer_opts
