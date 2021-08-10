function DrawerToggle()
  local lib = require'diffview.lib'
  local view = lib.get_current_diffview()
  if view then
    if vim.bo.filetype == 'DiffviewFiles' then
      vim.cmd(":DiffviewToggleFiles")
      else
      vim.cmd(":DiffviewFocusFiles")
    end
  else
      vim.cmd(":NvimTreeRefresh")
      vim.cmd(":NvimTreeToggle")
  end
end

local last_tabpage = vim.api.nvim_get_current_tabpage()

function CloseView()
  local lib = require'diffview.lib'
  local view = lib.get_current_diffview()
  if view then
    vim.cmd(":DiffviewClose")
  else
    vim.cmd(":bdelete")
  end
end


