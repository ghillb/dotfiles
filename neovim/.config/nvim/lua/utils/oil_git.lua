local M = {}

local git_signs = {
  OilGitAdded = { text = "+", texthl = "GitSignsAdd" },
  OilGitModified = { text = "~", texthl = "GitSignsChange" },
  OilGitRenamed = { text = "→", texthl = "GitSignsChange" },
  OilGitStaged = { text = "S", texthl = "GitSignsAdd" },
  OilGitUntracked = { text = "?", texthl = "GitSignsAdd" },
  OilGitIgnored = { text = "!", texthl = "Comment" },
  OilGitDirectory = { text = "~", texthl = "GitSignsChange" },
}

local function setup_signs()
  for name, opts in pairs(git_signs) do
    vim.fn.sign_define(name, opts)
  end
end

local function get_git_root(path)
  local git_path = vim.fs.find('.git', {
    path = path,
    upward = true,
    type = 'directory'
  })[1]
  return git_path and vim.fs.dirname(git_path) or nil
end

local function get_git_status(dir)
  local git_root = get_git_root(dir)
  if not git_root then
    return {}
  end

  local result = vim.system({"git", "status", "--porcelain", "--ignored"}, {
    cwd = git_root,
    text = true
  }):wait()
  
  if result.code ~= 0 then
    return {}
  end

  local status = {}
  for line in result.stdout:gmatch("[^\r\n]+") do
    if #line >= 3 then
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
      
      local abs_path = git_root .. "/" .. filepath
      status[abs_path] = status_code
      status[filepath] = status_code
    end
  end
  
  return status
end


local function get_sign_name(status_code)
  if not status_code then
    return nil
  end

  local first_char = status_code:sub(1, 1)
  local second_char = status_code:sub(2, 2)

  if second_char == "M" then
    return "OilGitModified"
  elseif second_char == "D" then
    return "OilGitModified"
  end
  
  if second_char == " " then
    if first_char == "A" then
      return "OilGitStaged"
    elseif first_char == "M" then
      return "OilGitStaged"
    elseif first_char == "R" then
      return "OilGitRenamed"
    elseif first_char == "D" then
      return "OilGitStaged"
    end
  end

  if status_code == "??" then
    return "OilGitUntracked"
  end

  if status_code == "!!" then
    return "OilGitIgnored"
  end

  return nil
end

local function clear_signs()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.fn.sign_unplace("oil_git_group", { buffer = bufnr })
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

  local git_status = get_git_status(current_dir)
  if vim.tbl_isempty(git_status) then
    clear_signs()
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  
  clear_signs()

  for i, line in ipairs(lines) do
    local entry = oil.get_entry_on_line(bufnr, i)
    if entry then
      local sign_name
      
      if entry.type == "file" then
        local git_root = get_git_root(current_dir)
        if git_root then
          local rel_current = current_dir:gsub("^" .. vim.pesc(git_root) .. "/?", "")
          rel_current = rel_current:gsub("/$", "")
          local rel_filepath = (rel_current == "" and "" or rel_current .. "/") .. entry.name
          local abs_filepath = git_root .. "/" .. rel_filepath
          
          local status_code = git_status[rel_filepath] or git_status[abs_filepath]
          
          sign_name = get_sign_name(status_code)
        end
      elseif entry.type == "directory" then
        local git_root = get_git_root(current_dir)
        if git_root then
          local rel_current = current_dir:gsub("^" .. vim.pesc(git_root) .. "/?", "")
          rel_current = rel_current:gsub("/$", "")
          local rel_dir = (rel_current == "" and "" or rel_current .. "/") .. entry.name .. "/"
          local abs_dir = git_root .. "/" .. rel_dir
          
          local status_code = git_status[rel_dir] or git_status[abs_dir]
          if status_code == "??" then
            sign_name = "OilGitUntracked"
          elseif status_code == "!!" then
            sign_name = "OilGitIgnored"
          else
            local has_working_changes = false
            local has_staged_only = false
            
            for file_path, file_status in pairs(git_status) do
              local file_rel_path = file_path:gsub("^" .. vim.pesc(git_root) .. "/?", "")
              if vim.startswith(file_rel_path, rel_dir:gsub("/$", "") .. "/") then
                local first_char = file_status:sub(1,1)
                local second_char = file_status:sub(2,2)
                
                if second_char == "M" or second_char == "D" then
                  has_working_changes = true
                  break
                elseif (first_char == "A" or first_char == "M" or first_char == "R" or first_char == "D") and second_char == " " then
                  has_staged_only = true
                end
              end
            end
            
            if has_working_changes then
              sign_name = "OilGitDirectory"
            elseif has_staged_only then
              sign_name = "OilGitStaged"
            end
          end
        end
      end
      
      if sign_name then
        vim.fn.sign_place(0, "oil_git_group", sign_name, bufnr, { lnum = i })
      end
    end
  end
end

local function setup_autocmds()
  local group = vim.api.nvim_create_augroup("OilGitStatus", { clear = true })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    pattern = "oil://*",
    callback = function()
      vim.schedule(apply_git_signs)
    end,
  })

  vim.api.nvim_create_autocmd("BufLeave", {
    group = group,
    pattern = "oil://*",
    callback = clear_signs,
  })

  vim.api.nvim_create_autocmd({"BufWritePost", "TextChanged", "TextChangedI"}, {
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
  apply_git_signs()
end


return M