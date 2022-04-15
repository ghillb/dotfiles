local packer_opts = {
  "folke/which-key.nvim",
  event = "VimEnter",
  cond = function()
    return not vim.g.vscode
  end,
  config = function()
    local ok, which_key = pcall(require, "which-key")
    if not ok then
      return
    end

    local config = {
      window = {
        border = "single",
      },
    }

    which_key.setup(config)
  end,
}
return packer_opts
