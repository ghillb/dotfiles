function DrawerToggle()
  local lib = require'diffview.lib'
  local view = lib.get_current_view()
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

function CloseView()
  local lib = require'diffview.lib'
  local view = lib.get_current_view()
  if view then
    vim.cmd(":DiffviewClose")
  else
    if packer_plugins['nvim-tree.lua'] then
      vim.cmd(":NvimTreeClose")
    end
    vim.cmd(":bdelete")
  end
end

local utils = require('telescope.utils')
local builtin = require('telescope.builtin')
_G.project_files = function()
    local _, ret, _ = utils.get_os_command_output({ 'git', 'rev-parse', '--is-inside-work-tree' })
    if ret == 0 then
        builtin.git_files()
    else
        builtin.find_files()
    end
end

