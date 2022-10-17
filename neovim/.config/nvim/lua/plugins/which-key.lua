local packer_opts = {
  "folke/which-key.nvim",
  event = "VimEnter",
  config = function()
    local ok, which_key = pcall(require, "which-key")
    if not ok then
      return
    end

    local config = {
      window = {
        border = "none",
      },
    }

    which_key.setup(config)
  end,
}
return packer_opts
