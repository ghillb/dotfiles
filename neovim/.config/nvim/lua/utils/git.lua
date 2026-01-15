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
    text = true
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
    end
  end
  
  local MAX_DIFF_CHARS = 15000
  local processed_diff = truncate_diff_simple(diff, MAX_DIFF_CHARS)
  
  local prompt = "Task: Generate a conventional commit message based on the provided code changes.\n\n" ..
               "Follow the Conventional Commits specification:\n" ..
               "Format: <type>[optional scope]: <description>\n\n" ..
               "Types: feat, fix, refactor, perf, docs, style, test, build, ci, chore\n" ..
               "Rules:\n" ..
               "1. Use lowercase for type and description\n" ..
               "2. Do not capitalize the first letter of description\n" ..
               "3. Do not end description with a period\n" ..
               "4. Use imperative present tense (add, not added)\n" ..
               "5. Keep description under 50 characters\n" ..
               "6. Add scope if relevant: type(scope): description\n" ..
               "7. Output ONLY the commit message, no explanation\n\n" ..
               "EXAMPLES:\n" ..
               "feat(auth): add login validation\n" ..
               "fix(ui): resolve button spacing issue\n" ..
               "refactor(config): simplify settings logic\n\n" ..
               "CODE CHANGES:\n" .. processed_diff
  
  local cmd = {}
  if vim.fn.executable('copilot') == 1 then
    cmd = {'copilot', '-p', prompt, '--silent', '--allow-all'}
  else
    if opts.callback then
      opts.callback(false, "Agent executable not found.")
    end
    return
  end
  
  vim.system(
    cmd,
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
        
        commit_msg = commit_msg:gsub('\n$', '')
        commit_msg = commit_msg:gsub('^```[^\n]*\n', ''):gsub('\n```$', '')
        commit_msg = commit_msg:gsub('^`+', ''):gsub('`+$', '')
        
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
