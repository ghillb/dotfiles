-- Custom user commands for Neovim

vim.api.nvim_create_user_command('CommitMsg', function()
  local diff = vim.fn.system('git diff --staged --no-color')
  
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to get git diff. Are you in a git repository?", vim.log.levels.ERROR)
    return
  end
  
  if diff == nil or diff:match("^%s*$") then
    vim.notify("No staged changes found. Stage some changes first with 'git add'", vim.log.levels.WARN)
    return
  end
  
  local prompt = "Write a professional conventional commit message for these staged changes. " ..
                 "Use one of these types: feat, fix, docs, style, refactor, perf, test, chore, build, ci. " ..
                 "Format: type(scope): description. Keep it concise and clear. " ..
                 "If there's a breaking change, add BREAKING CHANGE in the body. " ..
                 "IMPORTANT: Output ONLY the commit message text itself - no code blocks, no backticks, no markdown formatting, no explanations. " ..
                 "Just the plain commit message that will be used directly in git commit. " ..
                 "Here are the staged changes:\n\n" .. diff
  
  local escaped_prompt = vim.fn.shellescape(prompt)
  
  local ai_cmd = 'claude -p ' .. escaped_prompt
  
  vim.notify("Generating commit message...", vim.log.levels.INFO)
  
  local output = vim.fn.system(ai_cmd)
  
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to generate commit message. Make sure AI is aviable.", vim.log.levels.ERROR)
    return
  end
  
  if output == nil or output:match("^%s*$") then
    vim.notify("AI returned empty response. Please try again.", vim.log.levels.WARN)
    return
  end
  
  output = output:gsub('\n$', '')
  
  local lines = vim.split(output, '\n')
  
  table.insert(lines, '')
  
  vim.api.nvim_put(lines, 'c', false, true)
  
  vim.notify("Commit message generated successfully!", vim.log.levels.INFO)
end, {
  desc = "Generate conventional commit message for staged changes using AI"
})

