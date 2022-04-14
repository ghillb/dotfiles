function _G.DrawerToggle()
  local lib = require("diffview.lib")
  local view = lib.get_current_view()
  if view then
    if vim.bo.filetype == "DiffviewFiles" then
      vim.cmd(":DiffviewToggleFiles")
    else
      vim.cmd(":DiffviewFocusFiles")
    end
  else
    vim.cmd(":Neotree toggle reveal")
  end
end

function _G.CloseView()
  local lib = require("diffview.lib")
  local view = lib.get_current_view()
  if view then
    vim.cmd(":DiffviewClose")
  else
    if packer_plugins["neo-tree.nvim"] then
      vim.cmd(":Neotree close")
    end
    if vim.bo.filetype == "vim" then
      vim.cmd(":q")
    else
      vim.cmd(":bdelete")
    end
  end
end

function _G.TelescopeOmniFiles()
  -- git submodule status more stable?
  local builtin = require("telescope.builtin")
  local utils = require("telescope.utils")
  local _, res, _ = utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" })
  if res == 0 then
    builtin.git_files()
  else
    builtin.find_files()
  end
end

function _G.SwitchGitBranch()
  _G.SetRoot("git_worktree")
  vim.cmd("Git fetch --prune --verbose --all")
  require("telescope.builtin").git_branches()
end

function _G.PopulateInfo()
  local is_git_worktree = _G.IsGitWorkTree()
  _G.SetGitModifiedCount(is_git_worktree)
  _G.SetBreadcrumbs()
  _G.SetTitleString()
end

function _G.IsGitWorkTree()
  return vim.fn.exists("*FugitiveIsGitDir") and vim.fn.FugitiveIsGitDir() == 1
  -- non-vim-fugitive
  -- vim.fn.system('git rev-parse --is-inside-work-tree')
  -- return vim.v.shell_error
end

function _G.SetCurrentGitBranch(is_git_worktree)
  if is_git_worktree then
    vim.g.current_git_branch = " " .. vim.fn.FugitiveHead()
  else
    vim.g.current_git_branch = ""
  end
end

function _G.SetGitModifiedCount(is_git_worktree)
  if is_git_worktree then
    vim.g.git_modified_count = vim.fn.system('git diff --numstat | wc -l | tr -d "\n"')
  else
    vim.g.git_modified_count = ""
  end
end

function _G.SetBreadcrumbs()
  if vim.bo.filetype == "neoterm" then
    vim.g.breadcrumbs = vim.fn.expand("%:t")
  else
    vim.g.breadcrumbs = vim.fn.substitute(vim.fn.expand("%:p"), vim.env.HOME, "~", "")
  end
end

function _G.SetTitleString()
  local titlestring
  if _G.IsGitWorkTree() then
    titlestring = vim.fn.fnamemodify(vim.fn.FugitiveWorkTree(), ":t")
  else
    titlestring = vim.fn.substitute(vim.fn.expand("%:p:h:t"), vim.env.HOME, "~", "")
  end
  vim.opt.titlestring = "[" .. titlestring .. "]"
end

function _G.GetLinePercent()
  return math.floor(vim.fn.line(".") * 100 / vim.fn.line("$")) .. "%%"
end

function _G.GetIndicators()
  local indicators = ""
  if vim.b.copilot_enabled == nil or vim.b.copilot_enabled == true then
    indicators = indicators .. "C"
  end
  return indicators
end

function _G.GetActiveBuffers()
  local active_buffers = {}
  for k, value in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(value) and vim.api.nvim_buf_is_loaded(value) then
      active_buffers[tostring(k)] = vim.api.nvim_buf_get_name(value)
    end
  end
  return active_buffers
end

function _G.NewTerminal()
  if vim.api.nvim_buf_get_name(0):find("term://") then
    vim.cmd(":Tnew")
    vim.cmd(":Tnext")
  end
  vim.cmd(":Ttoggle")
  vim.api.nvim_feedkeys(vim.api.nvim_eval('"\\<c-w>ji"'), "m", true)
end

function _G.ToggleGutter()
  if vim.wo.scl:find("yes") then
    vim.g._scl = vim.wo.scl
    vim.wo.scl = "no"
  else
    vim.wo.scl = vim.g._scl
  end
  vim.wo.rnu = not vim.wo.rnu
  vim.wo.nu = not vim.wo.nu
end

function _G.TmuxSwitchPane(direction)
  local wnr = vim.fn.winnr()
  vim.fn.execute("wincmd " .. direction)
  if wnr == vim.fn.winnr() then
    vim.fn.system("tmux select-pane -" .. vim.fn.tr(direction, "phjkl", "lLDUR"))
  end
end

function _G.CreateOrGoToFile()
  local node_path = vim.fn.expand(vim.fn.expand("<cfile>"))
  if vim.fn.filereadable(node_path) == 0 and vim.fn.isdirectory(node_path) == 0 then
    local choice = vim.fn.confirm("Create new file: " .. node_path .. " ?", "&Yes\n&No", 1)
    if choice ~= 1 then
      return
    end
  end
  vim.fn.execute("vsplit " .. node_path)
end

function _G.SetRoot(...)
  if #(...) < 1 then
    return
  end
  local target, echo = ...

  if target == "git_worktree" then
    if _G.IsGitWorkTree() then
      vim.env.VIM_ROOT = vim.fn.FugitiveWorkTree()
    else
      print("not a git repo!")
      return
    end
  end
  if target == "parent_dir" then
    vim.env.VIM_ROOT = vim.fn.fnamemodify(vim.env.VIM_ROOT, ":h")
  end
  if target == "file_dir" then
    vim.env.VIM_ROOT = vim.fn.expand("%:p:h")
  end
  if target == "start_dir" then
    if _G.IsGitWorkTree() then
      _G.SetRoot("git_worktree", echo)
      return
    else
      vim.env.VIM_ROOT = vim.fn.fnamemodify(vim.env.VIM_ROOT, ":p:h")
    end
  end
  if target == "origin" then
    vim.env.VIM_ROOT = vim.env.PWD
  end
  if vim.fn.isdirectory(vim.env.VIM_ROOT) == 1 then
    vim.cmd("silent chdir " .. vim.env.VIM_ROOT)
    if echo then
      print(vim.fn.substitute(target, "_", " ", "") .. " rooted " .. " -> " .. vim.env.VIM_ROOT)
    end
  else
    print("directory doesn't exist")
  end
end

function _G.DisableTelescopeMappings()
  vim.api.nvim_buf_set_keymap(0, "", "<c-p>", "<nop>", { noremap = false, silent = true })
  vim.api.nvim_buf_set_keymap(0, "", "<c-e>", "<nop>", { noremap = false, silent = true })
  vim.api.nvim_buf_set_keymap(0, "", "<c-b>", "<nop>", { noremap = false, silent = true })
  vim.api.nvim_buf_set_keymap(0, "", "<c-g>", "<nop>", { noremap = false, silent = true })
  vim.api.nvim_buf_set_keymap(0, "", "<c-/>", "<nop>", { noremap = false, silent = true })
end

function table.merge(...)
  local result = {}
  for _, t in ipairs({ ... }) do
    for k, v in pairs(t) do
      result[k] = v
    end
  end
  return result
end

function _G.SplitStringIntoTable(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

function _G.filereadable(path)
  local f = io.open(path, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

function _G.P(table)
  print(vim.inspect(table))
end

function _G.switch(param, cases)
  local case = cases[param]
  if case then
    return case()
  end
  local def = cases["default"]
  return def and def() or nil
end

function _G.toggle_variable(args)
  local ok, val = pcall(vim.api.nvim_buf_get_var, 0, args.var)
  if not ok then
    vim.api.nvim_buf_set_var(0, args.var, args.default)
    return
  end
  vim.api.nvim_buf_set_var(0, args.var, not val)
end

-- tab key overload
local function replace_keycodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local _, neogen = pcall(require, "neogen")

function _G.tab_binding()
  if vim.fn.pumvisible() ~= 0 then
    return replace_keycodes("<C-n>")
  elseif neogen.jumpable() then
    return replace_keycodes("<cmd>lua require('neogen').jump_next()<cr>")
  elseif vim.fn["vsnip#available"](1) ~= 0 then
    return replace_keycodes("<plug>(vsnip-expand-or-jump)")
  else
    return replace_keycodes("<plug>(Tabout)")
  end
end

function _G.s_tab_binding()
  if vim.fn.pumvisible() ~= 0 then
    return replace_keycodes("<C-p>")
  elseif neogen.jumpable() then
    return replace_keycodes("<cmd>lua require('neogen').jump_prev()<cr>")
  elseif vim.fn["vsnip#jumpable"](-1) ~= 0 then
    return replace_keycodes("<plug>(vsnip-jump-prev)")
  else
    return replace_keycodes("<plug>(TaboutBack)")
  end
end
