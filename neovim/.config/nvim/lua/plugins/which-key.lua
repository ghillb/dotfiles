local packer_opts = {
  "folke/which-key.nvim",
  event = "VimEnter",
  cond = function()
    return vim.api.nvim_eval('!exists("g:vscode")')
  end,
  config = function()
    require("which-key").setup({
      window = {
        border = "single",
      },
    })
  end,
}
return packer_opts