local ok, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if not ok then
  return
end

local config = {
  highlight = {
    enable = true,
    disable = {},
  },
}

treesitter_configs.setup(config)

