function DrawerToggle()
  local lib = require'diffview.lib'
  local view = lib.get_current_view()
  if view then
    if vim.bo.filetype == 'DiffviewFiles' then
      vim.cmd(":DiffviewToggleFiles")
      else
      vim.cmd(":DiffviewFocusFiles")
    end
  else
      vim.cmd(":NvimTreeRefresh")
      vim.cmd(":NvimTreeToggle")
  end
end

function CloseView()
  local lib = require'diffview.lib'
  local view = lib.get_current_view()
  if view then
    vim.cmd(":DiffviewClose")
  else
    if packer_plugins['nvim-tree.lua'] then
      vim.cmd(":NvimTreeClose")
    end
    vim.cmd(":bdelete")
  end
end

function TelescopeOmniFiles()
  -- git submodule status more stable?
  local builtin = require('telescope.builtin')
  local utils = require('telescope.utils')
  local _, res, _ = utils.get_os_command_output({ 'git', 'rev-parse', '--is-inside-work-tree' })
  if res == 0 then
    builtin.git_files()
  else
    builtin.find_files()
  end
end

function PopulateInfo()
  local is_git_worktree = IsGitWorkTree()
  SetCurrentGitBranch(is_git_worktree)
  SetGitModifiedCount(is_git_worktree)
  SetBreadcrumbs()
  SetTitleString()
end

function IsGitWorkTree()
  return vim.fn.exists("*FugitiveIsGitDir") and vim.fn.FugitiveIsGitDir() == 1
  -- non-vim-fugitive
  -- vim.fn.system('git rev-parse --is-inside-work-tree')
  -- return vim.v.shell_error
end

function SetCurrentGitBranch(is_git_worktree)
  if is_git_worktree then
    vim.g.current_git_branch = ' ' .. vim.fn.FugitiveHead()
  else
    vim.g.current_git_branch = ''
  end
end

function SetGitModifiedCount(is_git_worktree)
  if is_git_worktree then
    vim.g.git_modified_count = vim.fn.system('git diff --numstat | wc -l | tr -d "\n"')
  else
    vim.g.git_modified_count = ''
  end
end

function SetBreadcrumbs()
  if vim.bo.filetype == 'neoterm' then
    vim.g.breadcrumbs = vim.fn.expand('%:t')
  else
    vim.g.breadcrumbs = vim.fn.substitute(vim.fn.expand('%:p'), vim.env.HOME, '~', '')
  end
end

function SetTitleString()
  local titlestring
  if IsGitWorkTree() then
    titlestring = vim.fn.fnamemodify(vim.fn.FugitiveWorkTree(), ':t')
  else
    titlestring = vim.fn.substitute(vim.fn.expand('%:p:h:t'), vim.env.HOME, '~', '')
  end
  vim.opt.titlestring = '[' .. titlestring .. ']'
end

function GetLinePercent()
  return math.floor(vim.fn.line('.') * 100 / vim.fn.line('$')) .. '%%'
end

function GetActiveBuffers()
 local active_buffers = {}
 for k, value in ipairs(vim.api.nvim_list_bufs()) do
   if vim.api.nvim_buf_is_valid(value) and vim.api.nvim_buf_is_loaded(value) then
    active_buffers[tostring(k)] = vim.api.nvim_buf_get_name(value)
   end
 end
 return active_buffers
end

function NewTerminal()
  if vim.api.nvim_buf_get_name(0):find('term://') then
    vim.cmd ':Tnew'
    vim.cmd ':Tnext'
  end
  vim.cmd ":Ttoggle"
  vim.api.nvim_feedkeys(vim.api.nvim_eval('"\\<c-w>ji"'), 'm', true)
end

