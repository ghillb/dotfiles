local packer_opts = {
  "folke/zen-mode.nvim",
  config = function()
    local ok, zen_mode = pcall(require, "zen_mode")
    if not ok then
      return
    end

    local config = {
      window = {
        backdrop = 0.95,
        width = 120,
        height = 0.95,
        options = {
          signcolumn = "yes",
          number = false,
          relativenumber = false,
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = "0",
          list = false, -- disable whitespace characters
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
        },
        twilight = { enabled = true },
        gitsigns = { enabled = true },
        tmux = { enabled = true },
        kitty = {
          enabled = false,
          font = "+2",
        },
      },
      -- callbacks
      on_open = function(win) end,
      on_close = function() end,
    }

    zen_mode.setup(config)
  end,
}
return packer_opts
