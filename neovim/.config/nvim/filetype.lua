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
      local buf_first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, true)[1]
      if buf_first_line:find("#!/usr/bin/env ansible") then
        return "ansible.yaml"
      end
      if buf_first_line:find("#!/usr/bin/env kubernetes") then
        return "kubernetes.yaml"
      end
    end,
    [".*gitlab[-]ci.*.yml"] = "gitlab-ci.yaml",
    [".*docker[-]compose.*.yml"] = "docker-compose.yaml",
  },
})
