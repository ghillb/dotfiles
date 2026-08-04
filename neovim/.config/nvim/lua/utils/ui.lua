local M = {}

function M.close_view()
  if vim.bo.filetype == "oil" then
    if vim.bo.modified then
      vim.cmd("write")
    else
      vim.api.nvim_buf_delete(0, { force = true })
    end
  elseif vim.bo.filetype == "vim" then
    vim.cmd(":q")
  else
    vim.cmd(":bdelete")
  end
end

function M.populate_info()
  M.set_title_string()
end

function M.set_title_string()
  local git = require("utils.git")
  local titlestring
  if git.is_git_work_tree() then
    titlestring = vim.fn.fnamemodify(git.get_git_work_tree_path(), ":t")
  else
    titlestring = vim.fn.substitute(vim.fn.expand("%:p:h:t"), vim.env.HOME, "~", "")
  end
  vim.opt.titlestring = "[" .. titlestring .. "]"
end

function M.toggle_gutter()
  if vim.wo.scl ~= "no" then
    vim.g._scl = vim.wo.scl
    vim.wo.scl = "no"
  else
    vim.wo.scl = vim.g._scl
  end
  vim.wo.foldcolumn = vim.wo.scl == "no" and "0" or "1"
  vim.wo.rnu = not vim.wo.rnu
  vim.wo.nu = not vim.wo.nu
end

return M
