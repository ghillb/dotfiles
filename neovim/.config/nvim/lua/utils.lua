_G.P = vim.pretty_print
_G.Indicators = {}
vim.fn.user = {}

function vim.fn.user.drawer_toggle()
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

function vim.fn.user.toggle_fugitive()
  vim.cmd(":Neotree close")
  if vim.bo.filetype == "fugitive" then
    vim.fn.feedkeys("gq")
  end
  vim.cmd(":G")
end

function vim.fn.user.close_view()
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

function vim.fn.user.populate_info()
  local is_git_worktree = vim.fn.user.is_git_work_tree()
  vim.fn.user.set_git_modified_count(is_git_worktree)
  vim.fn.user.set_title_string()
  -- vim.fn.user.set_win_bar()
end

function vim.fn.user.is_git_work_tree()
  vim.fn.system("git rev-parse --is-inside-work-tree")
  return vim.v.shell_error == 0
end

function vim.fn.user.get_git_work_tree_path()
  return vim.fn.trim((vim.fn.system("git rev-parse --show-toplevel 2>/dev/null")))
end

function vim.fn.user.set_git_modified_count(is_git_worktree)
  if is_git_worktree then
    local gitdiffnumstat = tonumber(vim.fn.system('git diff --numstat | wc -l | tr -d "\n"'))
    vim.g.git_modified_count = gitdiffnumstat or ""
  else
    vim.g.git_modified_count = ""
  end
end

function vim.fn.user.set_title_string()
  local titlestring
  if vim.fn.user.is_git_work_tree() then
    titlestring = vim.fn.fnamemodify(vim.fn.user.get_git_work_tree_path(), ":t")
  else
    titlestring = vim.fn.substitute(vim.fn.expand("%:p:h:t"), vim.env.HOME, "~", "")
  end
  vim.opt.titlestring = "[" .. titlestring .. "]"
end

function vim.fn.user.set_win_bar()
  local skip_excluded = function()
    local excluded_filetypes = {
      "help",
      "git",
      "packer",
      "neo-tree",
      "fugitive",
      "gitcommit",
      "Trouble",
      "spectre_panel",
      "neoterm",
    }

    local isfloat = vim.api.nvim_win_get_config(0).relative ~= ""
    if vim.tbl_contains(excluded_filetypes, vim.bo.filetype) or vim.bo.buftype == "nofile" or isfloat then
      vim.opt_local.winbar = nil
      return true
    end
    return false
  end

  if skip_excluded() then
    return
  end

  local ok, _ = pcall(vim.api.nvim_set_option_value, "winbar", "%=%f", { scope = "local" })
  if not ok then
    return
  end
end

function vim.fn.user.new_terminal()
  if vim.api.nvim_buf_get_name(0):find("term://") then
    vim.cmd(":Tnew")
    vim.cmd(":Tnext")
  end
  vim.cmd(":Ttoggle")
  vim.api.nvim_feedkeys(vim.api.nvim_eval('"\\<c-w>ji"'), "m", true)
end

function vim.fn.user.toggle_gutter()
  if vim.wo.scl ~= "no" then
    vim.g._scl = vim.wo.scl
    vim.wo.scl = "no"
  else
    vim.wo.scl = vim.g._scl
  end
  vim.wo.rnu = not vim.wo.rnu
  vim.wo.nu = not vim.wo.nu
end

function vim.fn.user.tmux_switch_pane(direction)
  local wnr = vim.fn.winnr()
  vim.fn.execute("wincmd " .. direction)
  if wnr == vim.fn.winnr() and vim.env.TMUX then
    vim.fn.system("tmux select-pane -" .. vim.fn.tr(direction, "phjkl", "lLDUR"))
  end
end

function vim.fn.user.create_or_go_to_file()
  local node_path = vim.fn.expand(vim.fn.expand("<cfile>"))
  if vim.fn.filereadable(node_path) == 0 and vim.fn.isdirectory(node_path) == 0 then
    local choice = vim.fn.confirm("Create new file: " .. node_path .. " ?", "&Yes\n&No", 1)
    if choice ~= 1 then
      return
    end
  end
  vim.fn.execute("vsplit " .. node_path)
end

function vim.fn.user.set_root(...)
  if #(...) < 1 or vim.g.vscode then
    return
  end
  local target, echo = ...

  if target == "git_worktree" then
    if vim.fn.user.is_git_work_tree() then
      vim.g.nvim_root = vim.fn.user.get_git_work_tree_path()
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
    if vim.fn.user.is_git_work_tree() then
      vim.fn.user.set_root("git_worktree", echo)
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

function vim.fn.user.disable_telescope_mappings()
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

function table.split_string_into_table(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

function vim.fn.user.filereadable(path)
  local f = io.open(path, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

function _G.switch(param, cases)
  local case = cases[param]
  if case then
    return case()
  end
  local def = cases["default"]
  return def and def() or nil
end

function vim.fn.user.reload(mod)
  package.loaded[mod] = nil
  require(mod)
end

function vim.fn.user.toggle_variable(args)
  local ok, val = pcall(vim.api.nvim_get_var, args.var)
  if not ok then
    vim.api.nvim_set_var(args.var, args.default)
    return
  end
  vim.api.nvim_set_var(args.var, not val)
end

-- tab key overload
local _, neogen = pcall(require, "neogen")

function vim.fn.user.tab_binding()
  if vim.fn.pumvisible() ~= 0 then
    return "<C-n>"
  elseif neogen.jumpable() then
    return "<cmd>lua require('neogen').jump_next()<cr>"
  elseif vim.fn["vsnip#available"](1) ~= 0 then
    return "<plug>(vsnip-expand-or-jump)"
  else
    return "<tab>"
  end
end

function vim.fn.user.s_tab_binding()
  if vim.fn.pumvisible() ~= 0 then
    return "<C-p>"
  elseif neogen.jumpable() then
    return "<cmd>lua require('neogen').jump_prev()<cr>"
  elseif vim.fn["vsnip#jumpable"](-1) ~= 0 then
    return "<plug>(vsnip-jump-prev)"
  else
    return "<c-d>"
  end
end
