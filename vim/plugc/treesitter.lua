local status_ok, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
  return
end

local config = {
  highlight = {
    enable = true,
    disable = {},
  },
}

treesitter_configs.setup(config)

