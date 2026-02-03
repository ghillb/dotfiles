local M = {}

function M.is_git_work_tree()
  local result = vim.system({'git', 'rev-parse', '--is-inside-work-tree'}):wait()
  return result.code == 0
end

function M.get_git_work_tree_path()
  local result = vim.system({'git', 'rev-parse', '--show-toplevel'}):wait()
  if result.code == 0 then
    return vim.trim(result.stdout)
  end
  return ""
end

local VALID_TYPES = {feat=1, fix=1, refactor=1, perf=1, docs=1, style=1, test=1, build=1, ci=1, chore=1}

local function extract_commit_msg(raw_output)
  if not raw_output or raw_output:match("^%s*$") then
    return nil, "empty response"
  end

  local function try_extract(text)
    local msg_type, scope, desc

    msg_type, scope, desc = text:match("(%w+)(%b())!:%s*([^\n]+)")
    if msg_type and VALID_TYPES[msg_type] then
      return msg_type .. scope .. "!: " .. vim.trim(desc)
    end

    msg_type, scope, desc = text:match("(%w+)(%b()):%s*([^\n]+)")
    if msg_type and VALID_TYPES[msg_type] then
      return msg_type .. scope .. ": " .. vim.trim(desc)
    end

    msg_type, desc = text:match("(%w+)!:%s*([^\n]+)")
    if msg_type and VALID_TYPES[msg_type] then
      return msg_type .. "!: " .. vim.trim(desc)
    end

    msg_type, desc = text:match("(%w+):%s*([^\n]+)")
    if msg_type and VALID_TYPES[msg_type] then
      return msg_type .. ": " .. vim.trim(desc)
    end

    return nil
  end

  for block in raw_output:gmatch("```[^\n]*\n(.-)```") do
    local msg = try_extract(block)
    if msg then return msg end
  end

  for inline in raw_output:gmatch("`([^`]+)`") do
    local msg = try_extract(inline)
    if msg then return msg end
  end

  for line in raw_output:gmatch("[^\n]+") do
    local msg = try_extract(line)
    if msg then return msg end
  end

  local trimmed = vim.trim(raw_output)
  if not trimmed:match("\n") then
    local msg = try_extract(trimmed)
    if msg then return msg end
  end

  return nil, "no valid commit message found in: " .. raw_output:sub(1, 100)
end

local function truncate_diff_simple(diff, max_total_chars)
  if string.len(diff) <= max_total_chars then
    return diff
  end
  
  local MAX_CHARS_PER_FILE = 500
  local files = {}
  local current_file = {}
  local lines = vim.split(diff, '\n', {plain = true})
  
  for _, line in ipairs(lines) do
    if line:match("^diff %-%-git") and #current_file > 0 then
      table.insert(files, table.concat(current_file, '\n'))
      current_file = {line}
    else
      table.insert(current_file, line)
    end
  end
  if #current_file > 0 then
    table.insert(files, table.concat(current_file, '\n'))
  end
  
  local result = {}
  local total_chars = 0
  local truncated_files = 0
  
  for _, file_diff in ipairs(files) do
    if total_chars >= max_total_chars then
      break
    end
    
    local remaining_budget = max_total_chars - total_chars
    local file_limit = math.min(MAX_CHARS_PER_FILE, remaining_budget)
    
    if string.len(file_diff) <= file_limit then
      table.insert(result, file_diff)
      total_chars = total_chars + string.len(file_diff)
    else
      table.insert(result, file_diff:sub(1, file_limit))
      total_chars = total_chars + file_limit
      truncated_files = truncated_files + 1
    end
  end
  
  local truncated_diff = table.concat(result, '\n\n')
  if truncated_files > 0 or #files > #result then
    local omitted_files = #files - #result
    truncated_diff = truncated_diff .. string.format("\n\n[... %d files truncated, %d files omitted due to size limits]", 
                                                      truncated_files, omitted_files)
  end
  
  return truncated_diff
end

function M.generate_commit_msg(opts)
  opts = opts or {}
  
  local git_root_result = vim.system({'git', 'rev-parse', '--show-toplevel'}):wait()
  local git_root
  
  if git_root_result.code ~= 0 then
    if opts.callback then
      opts.callback(false, "Failed to find git repository. Are you in a git repository?")
    end
    return
  end
  
  git_root = vim.trim(git_root_result.stdout)
  
  local diff_result = vim.system({'git', 'diff', '--staged', '--no-color'}, {
    cwd = git_root,
    text = true,
    timeout = 30000
  }):wait()
  
  if diff_result.code ~= 0 then
    if opts.callback then
      opts.callback(false, "Failed to get git diff. Are you in a git repository?")
    end
    return
  end
  
  local diff = diff_result.stdout
  if diff == nil or diff:match("^%s*$") then
    if opts.callback then
      opts.callback(false, "No staged changes found. Stage some changes first with 'git add'")
    end
    return
  end
  
  local has_precommit = vim.fn.executable('pre-commit') == 1
  local has_precommit_config = vim.fn.filereadable(git_root .. '/.pre-commit-config.yaml') == 1 or 
                                vim.fn.filereadable(git_root .. '/.pre-commit-config.yml') == 1
  
  if has_precommit and has_precommit_config then
    local git_dir_result = vim.system({'git', 'rev-parse', '--git-dir'}, {
      cwd = git_root,
      text = true
    }):wait()
    
    local hooks_installed = false
    if git_dir_result.code == 0 then
      local git_dir = vim.trim(git_dir_result.stdout)
      if not vim.startswith(git_dir, '/') then
        git_dir = git_root .. '/' .. git_dir
      end
      hooks_installed = vim.fn.filereadable(git_dir .. '/hooks/pre-commit') == 1
    end
    
    if not hooks_installed then
      vim.notify("Pre-commit config found but hooks not installed. Skipping pre-commit checks. Run: pre-commit install", vim.log.levels.WARN)
    else
      vim.notify("Running pre-commit hooks...", vim.log.levels.INFO)

      local precommit_result = vim.system({'pre-commit', 'run'}, {
        cwd = git_root,
        text = true,
        timeout = 120000,
        env = { PRE_COMMIT_NO_CONCURRENCY = '1' }
      }):wait()

      if precommit_result.code == 1 then
        vim.notify("Pre-commit output:\n" .. (precommit_result.stdout or ""), vim.log.levels.INFO)
        if opts.callback then
          opts.callback(false, "Pre-commit checks failed. Please review.")
        end
        return
      elseif precommit_result.code ~= 0 then
        if opts.callback then
          opts.callback(false, "Pre-commit hooks failed: " .. (precommit_result.stderr or precommit_result.stdout or "Unknown error"))
        end
        return
      end

      diff_result = vim.system({'git', 'diff', '--staged', '--no-color'}, {
        cwd = git_root,
        text = true,
        timeout = 30000
      }):wait()

      if diff_result.code ~= 0 or not diff_result.stdout or diff_result.stdout:match("^%s*$") then
        if opts.callback then
          opts.callback(false, "No staged changes after pre-commit. Files may have been unstaged.")
        end
        return
      end
      diff = diff_result.stdout
    end
  end
  
  local MAX_DIFF_CHARS = 15000
  local processed_diff = truncate_diff_simple(diff, MAX_DIFF_CHARS)
  
  local prompt = "Generate a conventional commit message for these changes.\n\n" ..
               "RULES:\n" ..
               "- Format: type(scope): description OR type: description\n" ..
               "- Types: feat|fix|refactor|perf|docs|style|test|build|ci|chore\n" ..
               "- Lowercase, imperative tense, no period, under 50 chars\n\n" ..
               "DIFF:\n" .. processed_diff .. "\n\n" ..
               "Reply with ONLY the commit message, nothing else."
  
  local cmd = {}
  if vim.fn.executable('copilot') == 1 then
    cmd = {'copilot', '--model', 'gpt-5-mini', '-s', '-p', prompt}
  else
    if opts.callback then
      opts.callback(false, "Agent executable not found.")
    end
    return
  end
  
  vim.system(
    cmd,
    {text = true, timeout = 60000},
    function(result)
      vim.schedule(function()
        
        if result.code ~= 0 then
          if opts.callback then
            opts.callback(false, "Failed to generate commit message. Make sure AI is available.")
          end
          return
        end
        
        local commit_msg, err = extract_commit_msg(result.stdout)
        if not commit_msg then
          if opts.callback then
            opts.callback(false, "Failed to extract commit message: " .. (err or "unknown error"))
          end
          return
        end

        if opts.commit then
          local commit_result = vim.system({'git', 'commit', '-m', commit_msg}, {
            cwd = git_root,
            text = true
          }):wait()
          
          if commit_result.code ~= 0 then
            if opts.callback then
              opts.callback(false, "Commit failed: " .. (commit_result.stderr or commit_result.stdout or "Unknown error"))
            end
          else
            if opts.callback then
              opts.callback(true, "Committed successfully!")
            end
          end
        else
          if opts.callback then
            opts.callback(true, commit_msg)
          end
        end
      end)
    end
  )
end

return M
