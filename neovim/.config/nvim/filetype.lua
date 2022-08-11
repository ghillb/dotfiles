vim.g.do_filetype_lua = 1 -- remove when 0.8 is released
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
      local buf_lines = vim.api.nvim_buf_get_lines(bufnr, 0, 1, true)
      if not buf_lines[1] then
        return
      end
      local buf_first_line = buf_lines[1]
      if buf_first_line:find("#!/usr/bin/env ansible") then
        return "ansible.yaml"
      end
      if buf_first_line:find("#!/usr/bin/env kubectl") then
        return "kubernetes.yaml"
      end
    end,
    [".*gitlab[-]ci.*.yml"] = "gitlab-ci.yaml",
    [".*docker[-]compose.*.yml"] = "docker-compose.yaml",
  },
})

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.bo.filetype == "" then
      vim.bo.filetype = "plain"
    end
    if vim.bo.buftype == "terminal" then
      vim.bo.filetype = "terminal"
    end
  end,
  group = vim.api.nvim_create_augroup("BufEnterFTGroup", { clear = true }),
})
