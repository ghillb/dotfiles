_G.P = vim.pretty_print

_G.user = { indicators = {}, fn = {} }

local git = require('utils.git')
local navigation = require('utils.navigation')
local ui = require('utils.ui')
local general = require('utils.general')

require('utils.table')

user.fn.close_view = ui.close_view
user.fn.populate_info = ui.populate_info
user.fn.set_title_string = ui.set_title_string
user.fn.set_win_bar = ui.set_win_bar
user.fn.toggle_gutter = ui.toggle_gutter

user.fn.is_git_work_tree = git.is_git_work_tree
user.fn.get_git_work_tree_path = git.get_git_work_tree_path
user.fn.generate_commit_msg = git.generate_commit_msg

user.fn.tmux_switch_pane = navigation.tmux_switch_pane
user.fn.create_or_go_to_file = navigation.create_or_go_to_file
user.fn.set_root = navigation.set_root

user.fn.filereadable = general.filereadable
user.fn.reload = general.reload
user.fn.toggle_variable = general.toggle_variable
user.fn.load_local_config = general.load_local_config

return {
  git = git,
  navigation = navigation,
  ui = ui,
  general = general
}