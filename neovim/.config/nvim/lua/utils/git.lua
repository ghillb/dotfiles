local M = {}

function M.is_git_work_tree()
  vim.fn.system("git rev-parse --is-inside-work-tree")
  return vim.v.shell_error == 0
end

function M.get_git_work_tree_path()
  return vim.fn.trim((vim.fn.system("git rev-parse --show-toplevel 2>/dev/null")))
end

function M.generate_commit_msg(opts)
  opts = opts or {}
  
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
  
  local git_root = vim.fn.trim(vim.fn.system('git rev-parse --show-toplevel 2>/dev/null'))
  if vim.v.shell_error ~= 0 then
    git_root = '.'
  end
  
  -- Check for pre-commit hooks
  local has_precommit = vim.fn.executable('pre-commit') == 1
  local has_precommit_config = vim.fn.filereadable(git_root .. '/.pre-commit-config.yaml') == 1 or 
                                vim.fn.filereadable(git_root .. '/.pre-commit-config.yml') == 1
  
  if has_precommit and has_precommit_config then
    -- Check if hooks are actually installed
    local hooks_installed = vim.fn.filereadable(git_root .. '/.git/hooks/pre-commit') == 1
    if not hooks_installed then
      if opts.callback then
        opts.callback(false, "Pre-commit config found but hooks not installed. Run: pre-commit install")
      end
      return
    end
    vim.notify("Running pre-commit hooks...", vim.log.levels.INFO)
    local precommit_result = vim.fn.system('PRE_COMMIT_NO_CONCURRENCY=1 pre-commit run')
    local precommit_exit_code = vim.v.shell_error
    
    if precommit_exit_code == 1 then
      vim.notify("Pre-commit output:\n" .. precommit_result, vim.log.levels.INFO)
      if opts.callback then
        opts.callback(false, "Pre-commit checks failed. Please review.")
      end
      return
    elseif precommit_exit_code ~= 0 then
      if opts.callback then
        opts.callback(false, "Pre-commit hooks failed: " .. precommit_result)
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
          if opts.callback then
            opts.callback(true, commit_msg)
          end
        end
      end)
    end
  )
end

return M
