-- Custom user commands for Neovim

-- Store the state of ongoing commit message generation
local commit_msg_state = {
  generating = false,
  target_buffer = nil
}

vim.api.nvim_create_user_command('CommitMsg', function()
  -- Don't allow multiple concurrent generations
  if commit_msg_state.generating then
    vim.notify("Already generating a commit message...", vim.log.levels.WARN)
    return
  end
  
  -- Store the current buffer
  commit_msg_state.target_buffer = vim.api.nvim_get_current_buf()
  commit_msg_state.generating = true
  
  -- Use the shared function from utils.lua
  user.fn.generate_commit_msg({
    callback = function(success, result)
      commit_msg_state.generating = false
      
      if not success then
        if result:match("No staged changes") then
          vim.notify(result, vim.log.levels.WARN)
        else
          vim.notify(result, vim.log.levels.ERROR)
        end
        return
      end
      
      -- Check if the target buffer still exists
      if not vim.api.nvim_buf_is_valid(commit_msg_state.target_buffer) then
        vim.notify("Target buffer was closed. Commit message: " .. vim.split(result, '\n')[1], vim.log.levels.WARN)
        return
      end
      
      -- Split the commit message into lines and insert at beginning of buffer
      local lines = vim.split(result, '\n')
      vim.api.nvim_buf_set_lines(commit_msg_state.target_buffer, 0, 0, false, lines)
    end
  })
end, {
  desc = "Generate conventional commit message for staged changes using AI (async)"
})

-- Add a command to check generation status
vim.api.nvim_create_user_command('CommitMsgStatus', function()
  if commit_msg_state.generating then
    vim.notify("Commit message generation in progress...", vim.log.levels.INFO)
  else
    vim.notify("No commit message generation in progress", vim.log.levels.INFO)
  end
end, {
  desc = "Check status of commit message generation"
})

