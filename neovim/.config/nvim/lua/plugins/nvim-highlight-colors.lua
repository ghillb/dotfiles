local packer_opts = {
  "brenoprata10/nvim-highlight-colors",
  disable = vim.env.NVIM_EMBEDDED == "true",
  config = function()
    local ok, colorizer = pcall(require, "nvim-highlight-colors")
    if not ok then
      return
    end

    colorizer.setup({
      render = "background", -- or 'foreground' or 'first_column'
      enable_tailwind = false,
    })
  end,
}
return packer_opts
