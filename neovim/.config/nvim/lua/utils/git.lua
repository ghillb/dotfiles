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
      if opts.callback then
        opts.callback(false, "Pre-commit config found but hooks not installed. Run: pre-commit install")
      end
      return
    end
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
  
  local prompt = "Write a professional conventional commit message for these staged changes. " ..
                 "Use one of these types: feat, fix, docs, style, refactor, perf, test, chore, build, ci. " ..
                 "Format: type(scope): description. Keep it concise and clear. " ..
                 "If there's a breaking change, add BREAKING CHANGE in the body. " ..
                 "IMPORTANT: Output ONLY the commit message text itself - no code blocks, no backticks, no markdown formatting, no explanations. " ..
                 "Just the plain commit message that will be used directly in git commit. " ..
                 "Here are the staged changes:\n\n" .. diff
  
  vim.system(
    {'claude', '-p'},
    {text = true, stdin = prompt},
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
