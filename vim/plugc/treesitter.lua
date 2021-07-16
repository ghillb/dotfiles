local status_ok, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
  return
end

local config = {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
    disable = {},
  },
}

treesitter_configs.setup(config)

