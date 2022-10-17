local packer_opts = {
  "stevearc/aerial.nvim",
  config = function()
    local ok, aerial = pcall(require, "aerial")
    if not ok then
      return
    end

    aerial.setup({})

    -- set keys
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>")
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>")
    vim.keymap.set("n", "[[", "<cmd>AerialPrevUp<CR>")
    vim.keymap.set("n", "]]", "<cmd>AerialNextUp<CR>")
  end,
}
return packer_opts
