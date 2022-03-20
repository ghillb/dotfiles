local packer_opts = {
  "rcarriga/vim-ultest",
  requires = { "vim-test/vim-test" },
  run = ":UpdateRemotePlugins",
  config = function()
    vim.g.ultest_use_pty = 1
    -- vim.g["test#python#pytest#options"] = "--color=yes"
    vim.keymap.set("n", "]t", "<Plug>(ultest-next-fail)")
    vim.keymap.set("n", "[t", "<Plug>(ultest-prev-fail)")
    local ag_ultest_runner = vim.api.nvim_create_augroup("UltestRunner", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", { command = "UltestNearest", group = ag_ultest_runner })
  end,
}
return packer_opts
