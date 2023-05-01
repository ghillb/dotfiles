local packer_opts = {
  "nvim-treesitter/nvim-treesitter",
  requires = { "nvim-treesitter/nvim-treesitter-context", "p00f/nvim-ts-rainbow", "nvim-treesitter/playground" },
  config = function()
    local ok, nvim_treesitter_configs = pcall(require, "nvim-treesitter.configs")
    if not ok or vim.g.vscode then
      return
    end

    local config = {
      highlight = {
        enable = true,
        disable = { "vim", "latex" },
        additional_vim_regex_highlighting = { "latex" },
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

    require("treesitter-context").setup({
      enable = false,
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
