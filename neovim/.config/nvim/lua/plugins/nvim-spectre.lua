local packer_opts = {
  "nvim-pack/nvim-spectre",
  config = function ()
    vim.keymap.set("n","<leader>/", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>")
    vim.keymap.set("v","<leader>/", "<cmd>lua require('spectre').open_visual()<CR>")
    vim.keymap.set("n","<leader>?", "viw:lua require('spectre').open_file_search()<cr>")
    require('spectre').setup()
  end
}
return packer_opts
