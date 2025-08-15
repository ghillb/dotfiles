_G.P = vim.pretty_print
_G.user = { indicators = {}, fn = {} }

function user.fn.drawer_toggle()

  vim.cmd(":Neotree toggle reveal")
end

function user.fn.close_view()
  -- Try to close neo-tree if it's open
  pcall(vim.cmd, "Neotree close")
  
  if vim.bo.filetype == "vim" then
    vim.cmd(":q")
  else
    vim.cmd(":bdelete")
  end
end

function user.fn.populate_info()
  user.fn.set_title_string()

end

function user.fn.is_git_work_tree()
  vim.fn.system("git rev-parse --is-inside-work-tree")
  return vim.v.shell_error == 0
end

function user.fn.get_git_work_tree_path()
  return vim.fn.trim((vim.fn.system("git rev-parse --show-toplevel 2>/dev/null")))
end

function user.fn.set_title_string()
  local titlestring
  if user.fn.is_git_work_tree() then
    titlestring = vim.fn.fnamemodify(user.fn.get_git_work_tree_path(), ":t")
  else
    titlestring = vim.fn.substitute(vim.fn.expand("%:p:h:t"), vim.env.HOME, "~", "")
  end
  vim.opt.titlestring = "[" .. titlestring .. "]"
end

function user.fn.set_win_bar()
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

function user.fn.toggle_gutter()
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

function user.fn.tmux_switch_pane(direction)
  local wnr = vim.fn.winnr()
  vim.fn.execute("wincmd " .. direction)
  if wnr == vim.fn.winnr() and vim.env.TMUX then
    vim.fn.system("tmux select-pane -" .. vim.fn.tr(direction, "phjkl", "lLDUR"))
  end
end

function user.fn.create_or_go_to_file()
  local node_path = vim.fn.expand(vim.fn.expand("<cfile>"))
  if vim.fn.filereadable(node_path) == 0 and vim.fn.isdirectory(node_path) == 0 then
    local choice = vim.fn.confirm("Create new file: " .. node_path .. " ?", "&Yes\n&No", 1)
    if choice ~= 1 then
      return
    end
  end
  vim.fn.execute("vsplit " .. node_path)
end

function user.fn.set_root(...)
  if #(...) < 1 or vim.g.vscode then
    return
  end
  local target, echo = ...

  if target == "git_worktree" then
    if user.fn.is_git_work_tree() then
      vim.g.nvim_root = user.fn.get_git_work_tree_path()
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
    if user.fn.is_git_work_tree() then
      user.fn.set_root("git_worktree", echo)
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

function table.merge(...)
  local result = {}
  for _, t in ipairs({ ... }) do
    for k, v in pairs(t) do
      result[k] = v
    end
  end
  return result
end

function table.deep_copy(t, seen)
  local result = {}
  seen = seen or {}
  seen[t] = result
  for key, value in pairs(t) do
    if type(value) == "table" then
      result[key] = seen[value] or table.deep_copy(value, seen)
    else
      result[key] = value
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

function user.fn.filereadable(path)
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

function user.fn.reload(mod)
  package.loaded[mod] = nil
  require(mod)
end

function user.fn.toggle_variable(args)
  local ok, val = pcall(vim.api.nvim_get_var, args.var)
  if not ok then
    vim.api.nvim_set_var(args.var, args.default)
    return
  end
  vim.api.nvim_set_var(args.var, not val)
end

function user.fn.load_local_config()
  local ok, localrc = pcall(require, "localrc")
  if ok then
    localrc.settings.load()
  end
end

-- Generate AI commit message for staged git changes
-- Options:
--   callback: function to call with (success, result) when done
--   commit: boolean - if true, commits automatically after generating message
function user.fn.generate_commit_msg(opts)
  opts = opts or {}
  
  -- Check for staged changes first
  local diff = vim.fn.system('git diff --staged --no-color')
  
  if vim.v.shell_error ~= 0 then
    if opts.callback then
      opts.callback(false, "Failed to get git diff. Are you in a git repository?")
    end
    return
  end
  
  if diff == nil or diff:match("^%s*$") then
    if opts.callback then
      opts.callback(false, "No staged changes found. Stage some changes first with 'git add'")
    end
    return
  end
  
  -- Build the prompt
  local prompt = "Write a professional conventional commit message for these staged changes. " ..
                 "Use one of these types: feat, fix, docs, style, refactor, perf, test, chore, build, ci. " ..
                 "Format: type(scope): description. Keep it concise and clear. " ..
                 "If there's a breaking change, add BREAKING CHANGE in the body. " ..
                 "IMPORTANT: Output ONLY the commit message text itself - no code blocks, no backticks, no markdown formatting, no explanations. " ..
                 "Just the plain commit message that will be used directly in git commit. " ..
                 "Here are the staged changes:\n\n" .. diff
  
  -- Use vim.system for async execution
  vim.system(
    {'claude', '-p', prompt},
    {text = true},
    function(result)
      vim.schedule(function()
        if result.code ~= 0 then
          if opts.callback then
            opts.callback(false, "Failed to generate commit message. Make sure AI is available.")
          end
          return
        end
        
        local commit_msg = result.stdout
        if commit_msg == nil or commit_msg:match("^%s*$") then
          if opts.callback then
            opts.callback(false, "AI returned empty response. Please try again.")
          end
          return
        end
        
        -- Remove trailing newline
        commit_msg = commit_msg:gsub('\n$', '')
        
        if opts.commit then
          -- Commit with the generated message
          local commit_result = vim.fn.system('git commit -m ' .. vim.fn.shellescape(commit_msg))
          
          if vim.v.shell_error ~= 0 then
            if opts.callback then
              opts.callback(false, "Commit failed: " .. commit_result)
            end
          else
            if opts.callback then
              opts.callback(true, "Committed successfully!")
            end
          end
        else
          -- Just return the message
          if opts.callback then
            opts.callback(true, commit_msg)
          end
        end
      end)
    end
  )
end

