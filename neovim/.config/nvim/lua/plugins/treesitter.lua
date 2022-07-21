local packer_opts = {
  "nvim-treesitter/nvim-treesitter",
  disable = vim.env.NVIM_EMBEDDED == "true",
  requires = { "nvim-treesitter/nvim-treesitter-context" },
  config = function()
    local ok, nvim_treesitter_configs = pcall(require, "nvim-treesitter.configs")
    if not ok or vim.g.vscode then
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

    nvim_treesitter_configs.setup(config)

    local parsers = require("nvim-treesitter.parsers")
    local yml_filetypes = { "ansible", "kubernetes", "docker-compose", "gitlab-ci" }
    for _, ft in ipairs(yml_filetypes) do
      parsers.filetype_to_parsername[ft .. ".yaml"] = "yaml"
    end

    parsers.get_parser_configs().norg = {
      install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg",
        files = { "src/parser.c", "src/scanner.cc" },
        branch = "main",
      },
    }

    require("treesitter-context").setup({
      enable = true,
      max_lines = 0,
      patterns = {
        default = {
          "class",
          "function",
          "method",
          -- 'for',
          -- 'while',
          -- 'if',
          -- 'switch',
          -- 'case',
        },
      },
      exact_patterns = {},
      zindex = 20,
    })
  end,
}
return packer_opts
