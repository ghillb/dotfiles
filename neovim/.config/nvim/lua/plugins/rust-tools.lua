local packer_opts = {
  "simrat39/rust-tools.nvim",
  requires = { "neovim/nvim-lspconfig" },
  config = function()
    local ok, rt = pcall(require, "rust-tools")
    if not ok then
      return
    end

    rt.setup({
      server = {
        on_attach = function(_, bufnr) end,
      },
    })
  end,
}
return packer_opts
