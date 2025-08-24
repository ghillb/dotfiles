local commit_msg_state = {
  generating = false,
  target_buffer = nil
}

vim.api.nvim_create_user_command('CommitMsg', function()
  if commit_msg_state.generating then
    vim.notify("Already generating a commit message...", vim.log.levels.WARN)
    return
  end
  
  commit_msg_state.target_buffer = vim.api.nvim_get_current_buf()
  commit_msg_state.generating = true
  
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
      
      if not vim.api.nvim_buf_is_valid(commit_msg_state.target_buffer) then
        vim.notify("Target buffer was closed. Commit message: " .. vim.split(result, '\n')[1], vim.log.levels.WARN)
        return
      end
      
      local lines = vim.split(result, '\n')
      vim.api.nvim_buf_set_lines(commit_msg_state.target_buffer, 0, 0, false, lines)
    end
  })
end, {
  desc = "Generate conventional commit message for staged changes using AI (async)"
})

vim.api.nvim_create_user_command('CommitMsgStatus', function()
  if commit_msg_state.generating then
    vim.notify("Commit message generation in progress...", vim.log.levels.INFO)
  else
    vim.notify("No commit message generation in progress", vim.log.levels.INFO)
  end
end, {
  desc = "Check status of commit message generation"
})

vim.api.nvim_create_user_command('CommitMsgCLI', function()
  require("utils.git").generate_commit_msg({
    callback = function(success, result)
      if success then
        print(result)
      else
        io.stderr:write("Error: " .. result .. "\n")
        vim.cmd("quit 1")
        return
      end
      vim.cmd("quit")
    end,
    commit = false
  })
end, {
  desc = "Generate commit message and output to stdout for CLI use"
})

