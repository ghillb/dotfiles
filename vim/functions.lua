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

function TelescopeOmniFiles()
  local builtin = require('telescope.builtin')
  local utils = require('telescope.utils')
  local _, res, _ = utils.get_os_command_output({ 'git', 'rev-parse', '--is-inside-work-tree' })
  if res == 0 then
    builtin.git_files()
  else
    builtin.find_files()
  end
end

