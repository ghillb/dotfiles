local packer_opts = {
  "hrsh7th/vim-vsnip",
  config = function()
    vim.g.vsnip_filetypes = { bash = { "sh" } }
    vim.g.vsnip_snippet_dir = "~/code/scripts/snippets"

    vim.keymap.set({ "i", "s" }, "<tab>", function()
      return vim.fn["vsnip#jumpable"](1) == 1 and "<plug>(vsnip-jump-next)" or "<tab>"
    end, { expr = true, remap = true })

    vim.keymap.set({ "i", "s" }, "<s-tab>", function()
      return vim.fn["vsnip#jumpable"](-1) == 1 and "<plug>(vsnip-jump-prev)" or "<s-tab>"
    end, { expr = true, remap = true })
  end,
}
return packer_opts
