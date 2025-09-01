local M = {}

local CACHE_TTL = 5000    
local DEBOUNCE_DELAY = 150 
local GIT_CMD = {"git", "status", "--porcelain=v1", "-z"}

local Cache = {
  git_roots = {},
  git_status = {},
  debounce_timers = {},
}

function Cache:get_git_root(path)
  if self.git_roots[path] then
    return self.git_roots[path]
  end
  
  local git_path = vim.fs.find('.git', {
    path = path,
    upward = true
  })[1]
  
  local git_root = nil
  if git_path then
    local stat = vim.uv.fs_stat(git_path)
    if stat and (stat.type == 'directory' or stat.type == 'file') then
      git_root = vim.fs.dirname(git_path)
    end
  end
  
  self.git_roots[path] = git_root
  return git_root
end

function Cache:get_status(git_root)
  local cached = self.git_status[git_root]
  if not cached or type(cached) ~= "table" then
    return nil
  end
  
  if not cached.data or not cached.timestamp or type(cached.timestamp) ~= "number" then
    return nil
  end
  
  local current_time = vim.uv.hrtime() 
  if not current_time or type(current_time) ~= "number" then
    return nil
  end
  
  current_time = current_time / 1000000
  if type(current_time) ~= "number" then
    return nil
  end
  
  local timestamp = cached.timestamp
  if not timestamp or type(timestamp) ~= "number" then
    return nil
  end
  
  local age = current_time - timestamp
  if type(age) == "number" and age < CACHE_TTL then
    return cached.data
  end
  
  return nil
end

function Cache:set_status(git_root, status)
  self.git_status[git_root] = {
    data = status,
    timestamp = vim.uv.hrtime() / 1000000
  }
end

function Cache:invalidate(git_root)
  if self.git_status[git_root] then
    self.git_status[git_root] = nil
  end
  for path, cached_root in pairs(self.git_roots) do
    if cached_root == git_root then
      self.git_roots[path] = nil
    end
  end
end

function Cache:clear()
  self.git_roots = {}
  self.git_status = {}
  
  for _, timer in pairs(self.debounce_timers) do
    if timer then
      timer:stop()
      timer:close()
    end
  end
  self.debounce_timers = {}
end

function Cache:debounce(git_root, callback)
  if self.debounce_timers[git_root] then
    self.debounce_timers[git_root]:stop()
    self.debounce_timers[git_root]:close()
  end
  
  local timer = vim.uv.new_timer()
  self.debounce_timers[git_root] = timer
  
  timer:start(DEBOUNCE_DELAY, 0, function()
    timer:stop()
    timer:close()
    self.debounce_timers[git_root] = nil
    
    vim.schedule(function()
      self:invalidate(git_root)
      callback()
    end)
  end)
end

local git_signs = {
  OilGitAdded = { text = "+", texthl = "GitSignsAdd" },
  OilGitModified = { text = "!", texthl = "GitSignsChange" },
  OilGitRenamed = { text = "→", texthl = "GitSignsChange" },
  OilGitStaged = { text = "+", texthl = "GitSignsAdd" },
  OilGitUntracked = { text = "?", texthl = "Statement" },
  OilGitIgnored = { text = "!", texthl = "Comment" },
  OilGitDirectory = { text = "!", texthl = "GitSignsChange" },
  OilGitConflict = { text = "💥", texthl = "DiagnosticError" },
  OilGitTypeChanged = { text = "T", texthl = "GitSignsChange" },
  OilGitDeleted = { text = "d", texthl = "GitSignsDelete" },
}

local function setup_signs()
  for name, opts in pairs(git_signs) do
    vim.fn.sign_define(name, opts)
  end
end

local function get_git_root(path)
  return Cache:get_git_root(path)
end

local function parse_git_status_line(line)
  if #line < 3 then return nil end
  
  local status_code = line:sub(1, 2)
  local filepath = line:sub(4)
  
  if status_code:sub(1, 1) == "R" then
    local arrow_pos = filepath:find(" %-> ")
    if arrow_pos then
      filepath = filepath:sub(arrow_pos + 4)
    end
  end
  
  if filepath:sub(1, 2) == "./" then
    filepath = filepath:sub(3)
  end
  
  return status_code, filepath
end

local function parse_git_output(stdout, git_root)
  local status = {}
  for line in stdout:gmatch("[^%z]+") do
    local status_code, filepath = parse_git_status_line(line)
    if status_code and filepath then
      local abs_path = git_root .. "/" .. filepath
      status[abs_path] = status_code
      status[filepath] = status_code
    end
  end
  return status
end

local function get_git_status_async(git_root, callback)
  vim.system(GIT_CMD, {
    cwd = git_root,
    text = true
  }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        callback({})
        return
      end

      local status = parse_git_output(result.stdout, git_root)
      Cache:set_status(git_root, status)
      callback(status)
    end)
  end)
end

local function get_git_status(dir)
  local git_root = get_git_root(dir)
  if not git_root then
    return {}
  end

  local cached_status = Cache:get_status(git_root)
  if cached_status then
    return cached_status
  end
  
  local result = vim.system(GIT_CMD, {
    cwd = git_root,
    text = true
  }):wait()
  
  if result.code ~= 0 then
    return {}
  end

  local status = parse_git_output(result.stdout, git_root)
  Cache:set_status(git_root, status)
  
  return status
end

local sign_lookup = {
  ["??"] = "OilGitUntracked",
  ["!!"] = "OilGitIgnored",
  [" M"] = "OilGitModified",
  [" D"] = "OilGitDeleted",
  ["A "] = "OilGitStaged",
  ["M "] = "OilGitStaged", 
  ["R "] = "OilGitRenamed",
  ["D "] = "OilGitStaged",
  ["MM"] = "OilGitModified",
  ["AM"] = "OilGitModified",
  ["AD"] = "OilGitDeleted",
  ["UU"] = "OilGitConflict",
  ["AA"] = "OilGitConflict",
  ["DD"] = "OilGitConflict",
  ["AU"] = "OilGitConflict",
  ["UA"] = "OilGitConflict",
  ["UD"] = "OilGitConflict",
  ["DU"] = "OilGitConflict",
  ["T "] = "OilGitStaged",
  [" T"] = "OilGitTypeChanged",
}

local function get_sign_name(status_code)
  return status_code and sign_lookup[status_code]
end

local function calculate_relative_path(current_dir, git_root)
  local rel_current = current_dir:gsub("^" .. vim.pesc(git_root) .. "/?", "")
  return rel_current:gsub("/$", "")
end

local function get_directory_status(git_status, git_root, rel_dir)
  for file_path, file_status in pairs(git_status) do
    local file_rel_path = file_path:gsub("^" .. vim.pesc(git_root) .. "/?", "")
    if vim.startswith(file_rel_path, rel_dir:gsub("/$", "") .. "/") then
      if file_status == "??" then
        return "OilGitUntracked"
      elseif file_status:sub(2, 2) == "M" or file_status:sub(2, 2) == "D" then
        return "OilGitDirectory"
      elseif file_status:sub(2, 2) == " " and file_status:sub(1, 1) ~= "?" then
        return "OilGitStaged"
      end
    end
  end
  return nil
end

local function clear_signs()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.fn.sign_unplace("oil_git_group", { buffer = bufnr })
end

local function debounced_refresh(git_root, callback)
  Cache:debounce(git_root, callback)
end

local function apply_git_signs()
  local ok, oil = pcall(require, "oil")
  if not ok then
    return
  end
  
  local current_dir = oil.get_current_dir()
  
  if not current_dir then
    clear_signs()
    return
  end

  local git_root = get_git_root(current_dir)
  if not git_root then
    clear_signs()
    return
  end

  local git_status = get_git_status(current_dir)
  if vim.tbl_isempty(git_status) then
    clear_signs()
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  
  clear_signs()

  local rel_current = calculate_relative_path(current_dir, git_root)
  
  for i, line in ipairs(lines) do
    local entry = oil.get_entry_on_line(bufnr, i)
    if not entry then goto continue end
    
    local sign_name
    
    if entry.type == "file" or entry.type == "link" then
      local rel_filepath = (rel_current == "" and "" or rel_current .. "/") .. entry.name
      local abs_filepath = git_root .. "/" .. rel_filepath
      local status_code = git_status[rel_filepath] or git_status[abs_filepath] or git_status[entry.name]
      
      if not status_code then
        local rel_dir = rel_current == "" and "" or rel_current .. "/"
        local parent_dir_with_slash = rel_dir
        if git_status[parent_dir_with_slash] == "??" then
          status_code = "??"
        end
      end
      
      sign_name = get_sign_name(status_code)
      
    elseif entry.type == "directory" then
      local rel_dir = (rel_current == "" and "" or rel_current .. "/") .. entry.name .. "/"
      local abs_dir = git_root .. "/" .. rel_dir
      local status_code = git_status[rel_dir] or git_status[abs_dir]
      
      if status_code == "??" then
        sign_name = "OilGitUntracked"
      elseif status_code == "!!" then
        sign_name = "OilGitIgnored"
      else
        sign_name = get_directory_status(git_status, git_root, rel_dir)
      end
    end
    
    if sign_name then
      vim.fn.sign_place(0, "oil_git_group", sign_name, bufnr, { lnum = i })
    end
    
    ::continue::
  end
  
  local cached = Cache.git_status[git_root]
  if cached and cached.timestamp and (vim.uv.hrtime() / 1000000 - cached.timestamp) > (CACHE_TTL * 0.7) then
    get_git_status_async(git_root, function(status)
      if oil.get_current_dir() == current_dir then
        apply_git_signs()
      end
    end)
  end
end

local function setup_autocmds()
  local group = vim.api.nvim_create_augroup("OilGitStatus", { clear = true })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    pattern = "oil://*",
    callback = function()
      vim.defer_fn(apply_git_signs, 50)
    end,
  })

  -- vim.api.nvim_create_autocmd("BufLeave", {
  --   group = group,
  --   pattern = "oil://*",
  --   callback = clear_signs,
  -- })

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    pattern = "oil://*",
    callback = function()
      vim.schedule(apply_git_signs)
    end,
  })

  vim.api.nvim_create_autocmd({"FocusGained", "WinEnter", "BufWinEnter"}, {
    group = group,
    pattern = "oil://*",
    callback = function()
      vim.schedule(apply_git_signs)
    end,
  })
end

function M.setup()
  setup_signs()
  setup_autocmds()
end

function M.refresh()
  local ok, oil = pcall(require, "oil")
  if not ok then return end
  
  local current_dir = oil.get_current_dir()
  if not current_dir then return end
  
  local git_root = get_git_root(current_dir)
  if not git_root then 
    apply_git_signs()
    return 
  end
  
  debounced_refresh(git_root, function()
    apply_git_signs()
  end)
end

function M.clear_cache()
  Cache:clear()
end

function M.invalidate_git_root(git_root)
  Cache:invalidate(git_root)
end

function M.get_git_root(path)
  return Cache:get_git_root(path)
end

function M.toggle_stage_current_file()
  local ok, oil = pcall(require, "oil")
  if not ok then
    vim.api.nvim_echo({{"Oil not available", "ErrorMsg"}}, false, {})
    return false
  end
  
  local entry = oil.get_cursor_entry()
  if not entry or (entry.type ~= "file" and entry.type ~= "link") then
    vim.api.nvim_echo({{"Please select a file to stage/unstage", "WarningMsg"}}, false, {})
    return false
  end
  
  local current_dir = oil.get_current_dir()
  local git_root = Cache:get_git_root(current_dir)
  
  if not git_root then
    vim.api.nvim_echo({{"Not in a git repository", "WarningMsg"}}, false, {})
    return false
  end
  
  local file_path = current_dir .. entry.name
  local git_status_result = vim.system({"git", "status", "--porcelain=v1"}, {cwd = git_root}):wait()
  local is_staged = false
  local has_conflicts = false
  
  if git_status_result.code == 0 and git_status_result.stdout then
    local rel_path = file_path:gsub("^" .. vim.pesc(git_root) .. "/", "")
    for line in git_status_result.stdout:gmatch("[^\n]+") do
      local status_code = line:sub(1, 2)
      local filepath = line:sub(4)
      if filepath == rel_path then
        if status_code == "UU" or status_code == "AA" or status_code == "DD" or 
           status_code == "AU" or status_code == "UA" or status_code == "UD" or status_code == "DU" then
          has_conflicts = true
        elseif status_code:sub(1, 1) ~= " " and status_code:sub(1, 1) ~= "?" then
          is_staged = true
        end
        break
      end
    end
  end
  
  if has_conflicts then
    vim.api.nvim_echo({{"Cannot stage file with merge conflicts. Resolve conflicts first.", "ErrorMsg"}}, false, {})
    return false
  end
  
  local cmd = is_staged and {"git", "restore", "--staged", file_path} or {"git", "add", "-f", file_path}
  local result = vim.system(cmd, {cwd = git_root}):wait()
  
  if result.code == 0 then
    Cache:invalidate(git_root)
    M.refresh()
    return true
  else
    local error_msg = result.stderr or "Unknown error"
    if error_msg:match("needs merge") or error_msg:match("conflict") then
      vim.api.nvim_echo({{"Cannot stage file with merge conflicts. Resolve conflicts first.", "ErrorMsg"}}, false, {})
    else
      vim.api.nvim_echo({{"Failed to toggle staging: " .. error_msg, "ErrorMsg"}}, false, {})
    end
    return false
  end
end

return M

