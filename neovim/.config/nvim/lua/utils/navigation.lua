local M = {}

function M.tmux_switch_pane(direction)
  local wnr = vim.fn.winnr()
  vim.fn.execute("wincmd " .. direction)
  if wnr == vim.fn.winnr() and vim.env.TMUX then
    vim.fn.system("tmux select-pane -" .. vim.fn.tr(direction, "phjkl", "lLDUR"))
  end
end

function M.create_or_go_to_file()
  local node_path = vim.fn.expand(vim.fn.expand("<cfile>"))
  if vim.fn.filereadable(node_path) == 0 and vim.fn.isdirectory(node_path) == 0 then
    local choice = vim.fn.confirm("Create new file: " .. node_path .. " ?", "&Yes\n&No", 1)
    if choice ~= 1 then
      return
    end
  end
  vim.fn.execute("vsplit " .. node_path)
end

function M.set_root(...)
  if #(...) < 1 or vim.g.vscode then
    return
  end
  local target, echo = ...
  
  local git = require('utils.git')

  if target == "git_worktree" then
    if git.is_git_work_tree() then
      vim.g.nvim_root = git.get_git_work_tree_path()
    else
      print("not a git repo!")
      return
    end
  end
  if target == "parent_dir" then
    vim.g.nvim_root = vim.fn.fnamemodify(vim.g.nvim_root, ":h")
  end
  if target == "file_dir" then
    vim.g.nvim_root = vim.fn.expand("%:p:h")
  end
  if target == "start_dir" then
    if git.is_git_work_tree() then
      M.set_root("git_worktree", echo)
      return
    else
      vim.g.nvim_root = vim.fn.fnamemodify(vim.g.nvim_root, ":p:h")
    end
  end
  if target == "origin" then
    vim.g.nvim_root = vim.env.PWD
  end
  if vim.fn.isdirectory(vim.g.nvim_root) == 1 then
    vim.cmd("silent chdir " .. vim.g.nvim_root)
    if echo then
      print(vim.fn.substitute(target, "_", " ", "") .. " rooted " .. " -> " .. vim.g.nvim_root)
    end
  else
    print("directory doesn't exist")
  end
end

return M