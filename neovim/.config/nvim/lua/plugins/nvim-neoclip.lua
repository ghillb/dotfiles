local packer_opts = {
  "AckslD/nvim-neoclip.lua",
  config = function()
    local ok, neoclip = pcall(require, "neoclip")
    if not ok then
      return
    end

    local config = {
      history = 1000,
      enable_persistent_history = true,
      continious_sync = true,
      db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
    }
    neoclip.setup(config)
  end,
}
return packer_opts
