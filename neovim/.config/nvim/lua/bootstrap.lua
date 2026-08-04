local M = {}

local function config_source_path()
  local init_path = vim.fn.stdpath("config") .. "/init.lua"
  return vim.fn.fnamemodify(vim.fn.resolve(init_path), ":h")
end

local function ensure_directories()
  local config_path = vim.fn.stdpath("config")

  vim.fn.mkdir(config_path .. "/lua/plugins", "p")
  vim.fn.mkdir(config_path .. "/after/ftplugin", "p")
end

function M.setup()
  ensure_directories()

  -- Bootstrap lazy.nvim
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  -- Load all plugin specs from lua/plugins/*.lua
  if vim.fn.has("unix") == 1 then
    require("lazy").setup("plugins", {
      lockfile = config_source_path() .. "/lazy-lock.json",
    })
  end
end

M.setup()

return M
