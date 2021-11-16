vim.cmd "au DirChanged * if filereadable(expand('%:p:h') . '/.exrc.vim') | source %:p:h/.exrc.vim | endif"
vim.cmd "au BufEnter * lua PopulateInfo()"
vim.cmd "au VimEnter * if filereadable(expand($NVC) . '/localrc.vim') | source $NVC/localrc.vim | endif | silent lua SetRoot('start_dir')"
vim.cmd "au TextChanged,TextChangedI * if &readonly == 0 && filereadable(bufname('%')) | silent write | endif"
vim.cmd "au TextYankPost * silent! lua vim.highlight.on_yank{higroup='IncSearch', timeout=500}"

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

function ToggleGutter()
  if vim.wo.scl == 'yes' then vim.wo.scl = 'no' else vim.wo.scl = 'yes' end
  vim.wo.rnu = not vim.wo.rnu
  vim.wo.nu = not vim.wo.nu
end

function TmuxSwitchPane(direction)
  local wnr = vim.fn.winnr()
  vim.fn.execute('wincmd ' .. direction)
  if wnr == vim.fn.winnr() then
    vim.fn.system('tmux select-pane -' .. vim.fn.tr(direction, 'phjkl', 'lLDUR'))
  end
end

function CreateOrGoToFile()
  local node_path = vim.fn.expand(vim.fn.expand('<cfile>'))
  if (vim.fn.filereadable(node_path) == 0 and vim.fn.isdirectory(node_path) == 0) then
    local choice = vim.fn.confirm("Create new file: " .. node_path .. " ?", "&Yes\n&No", 1)
    if choice ~= 1 then
      return
    end
  end
  vim.fn.execute("vsplit " .. node_path)
end

function SetRoot(...)
  vim.env.VIM_ROOT = vim.fn.getcwd()
  if #(...) < 1 then return end
  if ... == 'git_worktree' then
    if IsGitWorkTree() then
      vim.env.VIM_ROOT = vim.fn.FugitiveWorkTree()
    else
      print('not a git repo!')
      return
    end
  end
  if ... == 'parent_dir' then
    vim.env.VIM_ROOT = vim.fn.fnamemodify(vim.env.VIM_ROOT, ':h')
  end
  if ... == 'current_dir' then
    vim.env.VIM_ROOT = vim.fn.expand('%:p:h')
  end
  if ... == 'start_dir' then
    if IsGitWorkTree() then
      SetRoot('git_worktree')
      return
    else
      vim.env.VIM_ROOT = vim.fn.fnamemodify(vim.env.VIM_ROOT, ':p:h')
    end
  end
  if vim.fn.isdirectory(vim.env.VIM_ROOT) == 1 then
    vim.cmd( "silent chdir " .. vim.env.VIM_ROOT)
    print(vim.fn.substitute(..., "_", " ", "") .. ' rooted ' .. " -> " .. vim.env.VIM_ROOT)
  else
    print("directory doesn't exist")
  end
end

