local ok, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if not ok then
  return
end

local config = {
  highlight = {
    enable = true,
    disable = {},
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

