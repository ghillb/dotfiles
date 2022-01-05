-- https://github.com/neovim/neovim/pull/16600
-- vim.g.do_filetype_lua = 1
vim.filetype.add({
  filename = {
    ["README$"] = function(path, bufnr)
      if string.find("#", vim.api.nvim_buf_get_lines(bufnr, 0, 1, true)) then
        return "markdown"
      end
    end,
    [".*"] = function(path, bufnr)
      if vim.api.nvim_buf_get_lines(bufnr, 0, 1, true):match("#!/usr/bin/env ansible-playbook") then
        return "ansible"
      end
    end,
  },
})

