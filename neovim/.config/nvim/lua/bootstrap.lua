

local M = {}

local function ensure_directories()
  local config_path = vim.fn.stdpath("config")
  local pack_path = config_path .. "/pack/plugins"

  vim.fn.mkdir(pack_path .. "/start", "p")
  vim.fn.mkdir(pack_path .. "/opt", "p")

  vim.fn.mkdir(config_path .. "/lua/plugins", "p")
  vim.fn.mkdir(config_path .. "/after/ftplugin", "p")
end

function M.setup()
  ensure_directories()

end

M.setup()

return M