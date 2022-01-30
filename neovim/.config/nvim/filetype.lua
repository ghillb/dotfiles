vim.g.do_filetype_lua = 1
vim.filetype.add({
  extension = {
    tf = "terraform",
  },
  filename = {
    [".tasks"] = "dosini",
    [".envrc"] = "sh",
  },
  pattern = {
    [".*"] = function(path, bufnr)
      if vim.api.nvim_buf_get_lines(bufnr, 0, 1, true)[1]:find("#!/usr/bin/env ansible") then
        return "ansible"
      end
    end,
    [".*gitlab[-]ci.*.yml"] = "gitlab-ci",
    [".*docker[-]compose.*.yml"] = "docker-compose",
  },
})
