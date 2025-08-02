
local M = {}

local plugins = {

  ["vim-surround"] = "https://github.com/tpope/vim-surround",

  ["vim-illuminate"] = "https://github.com/RRethy/vim-illuminate",
  ["lualine.nvim"] = "https://github.com/nvim-lualine/lualine.nvim",
  ["cybu.nvim"] = "https://github.com/ghillb/cybu.nvim",

  -- Folke's plugins
  ["trouble.nvim"] = "https://github.com/folke/trouble.nvim",
  ["todo-comments.nvim"] = "https://github.com/folke/todo-comments.nvim",
  ["which-key.nvim"] = "https://github.com/folke/which-key.nvim",
  ["persistence.nvim"] = "https://github.com/folke/persistence.nvim",
  ["twilight.nvim"] = "https://github.com/folke/twilight.nvim",
  ["zen-mode.nvim"] = "https://github.com/folke/zen-mode.nvim",

  ["neo-tree.nvim"] = "https://github.com/nvim-neo-tree/neo-tree.nvim",
  ["plenary.nvim"] = "https://github.com/nvim-lua/plenary.nvim",
  ["nvim-web-devicons"] = "https://github.com/nvim-tree/nvim-web-devicons",
  ["nui.nvim"] = "https://github.com/MunifTanjim/nui.nvim",
}

-- Clone a plugin if it doesn't exist
local function ensure_plugin(name, url)
  local install_path = vim.fn.stdpath("config") .. "/pack/plugins/start/" .. name
  if vim.fn.isdirectory(install_path) == 0 then
    print("Cloning " .. name .. "...")
    vim.fn.system({"git", "clone", "--depth=1", url, install_path})
    if vim.v.shell_error ~= 0 then
      print("Failed to clone " .. name)
    else
      print("Successfully cloned " .. name)
    end
  end
end

local function load_plugin_config(name)
  local config_name = name:gsub("%.nvim$", ""):gsub("%-", "_")
  local config_path = "plugins." .. config_name
  local ok, config = pcall(require, config_path)
  if ok and type(config) == "function" then
    config()
  end
end

function M.setup()

  if vim.fn.has("unix") ~= 1 then
    return
  end

  for name, url in pairs(plugins) do
    ensure_plugin(name, url)
  end

  vim.cmd("silent! helptags ALL")

  load_plugin_config("plenary")
  load_plugin_config("nvim-web-devicons")
  load_plugin_config("nui")

  load_plugin_config("vim-illuminate")
  load_plugin_config("trouble")
  load_plugin_config("todo-comments")
  load_plugin_config("which-key")
  load_plugin_config("persistence")
  load_plugin_config("twilight")
  load_plugin_config("zen-mode")
  load_plugin_config("lualine")
  load_plugin_config("neo-tree")
  load_plugin_config("cybu")
end

vim.api.nvim_create_user_command("UpdatePlugins", function()
  for name, _ in pairs(plugins) do
    local install_path = vim.fn.stdpath("config") .. "/pack/plugins/start/" .. name
    if vim.fn.isdirectory(install_path) == 1 then
      print("Updating " .. name .. "...")
      vim.fn.system({"git", "-C", install_path, "pull"})
      if vim.v.shell_error == 0 then
        print("Updated " .. name)
      else
        print("Failed to update " .. name)
      end
    end
  end
  vim.cmd("helptags ALL")
end, {})

M.setup()

return M
