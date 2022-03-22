local packer_opts = {
  "rcarriga/vim-ultest",
  requires = { "vim-test/vim-test" },
  run = ":UpdateRemotePlugins",
  config = function()
    vim.g.ultest_use_pty = 1
    -- vim.g["test#python#pytest#options"] = "--color=yes"
    local ag_ultest_runner = vim.api.nvim_create_augroup("UltestRunner", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", { command = "UltestNearest", group = ag_ultest_runner })

    vim.keymap.set("n", "]t", "<plug>(ultest-next-fail)")
    vim.keymap.set("n", "[t", "<plug>(ultest-prev-fail)")
    vim.keymap.set("n", "<c-t><c-f>", "<plug>(ultest-run-file)")
    vim.keymap.set("n", "<c-t><c-t>", "<plug>(ultest-run-nearest)")
    vim.keymap.set("n", "<c-t><c-l>", "<plug>(ultest-run-last)")
    vim.keymap.set("n", "<c-t><c-n>", "<plug>(ultest-stop-nearest)")
    vim.keymap.set("n", "<c-t><c-s>", "<plug>(ultest-stop-file)")
    vim.keymap.set("n", "<leader>ts", "<plug>(ultest-summary-toggle)")
    vim.keymap.set("n", "<leader>to", "<plug>(ultest-output-show)")
    vim.keymap.set("n", "<leader>dua", "<plug>(ultest-attach)")
    vim.keymap.set("n", "<leader>dun", "<plug>(ultest-debug-nearest)")
    vim.keymap.set("n", "<leader>duu", "<plug>(ultest-debug)")
  end,
}
return packer_opts
