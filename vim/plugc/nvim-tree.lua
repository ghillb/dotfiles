local ok, nvimtree_config = pcall(require, 'nvim-tree.config')
if not ok then
  return
end

vim.g.nvim_tree_side = 'left'
vim.g.nvim_tree_width = 30
vim.g.nvim_tree_ignore = { '.git', 'node_modules', '.cache' }
vim.g.nvim_tree_gitignore = 1
vim.g.nvim_tree_auto_open = 1
vim.g.nvim_tree_auto_close = 1
vim.g.nvim_tree_auto_ignore_ft = { 'startify', 'dashboard', 'copy-mode'}
vim.g.nvim_tree_quit_on_open = 0
vim.g.nvim_tree_follow = 1
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_hide_dotfiles = 1
vim.g.nvim_tree_git_hl = 0
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_root_folder_modifier = ':~'
vim.g.nvim_tree_tab_open = 1
vim.g.nvim_tree_auto_resize = 0
vim.g.nvim_tree_disable_netrw = 0
vim.g.nvim_tree_hijack_netrw = 0
vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_lsp_diagnostics = 1
vim.g.nvim_tree_disable_window_picker = 1
vim.g.nvim_tree_disable_default_keybindings = 1
vim.g.nvim_tree_hijack_cursor = 1
vim.g.nvim_tree_icon_padding = ' '
vim.g.nvim_tree_update_cwd = 1
vim.g.nvim_tree_show_icons = { git = 1, folders = 0, files = 0, folder_arrows = 1 }
vim.g.nvim_tree_window_picker_exclude = { filetype = { packer, qf }, buftype = { terminal } }
vim.g.nvim_tree_icons = {
  default = '', -- ''
  symlink = '',
  git = {
    unstaged = "!",
    staged = "✓",
    unmerged = "",
    renamed = "➜",
    untracked = "?",
    deleted = "◯",
    ignored = "∅"
  },
  folder = {
    arrow_open = "",
    arrow_closed = "",
    default = "",
    open = "",
    empty = "",
    empty_open = "",
    symlink = "",
    symlink_open = "",
  },
  lsp = {
    hint = "",
    info = "",
    warning = "",
    error = "",
  }
}

local tree_cb = nvimtree_config.nvim_tree_callback

vim.g.nvim_tree_bindings = {
  { key = {"o", "l"},                     cb = tree_cb("edit") },
  { key = "<CR>",                         cb = tree_cb("cd") },
  { key = "<C-v>",                        cb = tree_cb("vsplit") },
  { key = "<C-s>",                        cb = tree_cb("split") },
  { key = "<C-t>",                        cb = tree_cb("tabnew") },
  { key = "<C-l>",                        cb = tree_cb("refresh") },
  { key = "K",                            cb = tree_cb("prev_sibling") },
  { key = "J",                            cb = tree_cb("next_sibling") },
  { key = "<",                            cb = tree_cb("first_sibling") },
  { key = ">",                            cb = tree_cb("last_sibling") },
  { key = "P",                            cb = tree_cb("parent_node") },
  { key = "h",                            cb = tree_cb("close_node") },
  { key = "<BS>",                         cb = tree_cb("dir_up") },
  { key = "<Tab>",                        cb = tree_cb("preview") },
  { key = "i",                            cb = tree_cb("toggle_ignored") },
  { key = ".",                            cb = tree_cb("toggle_dotfiles") },
  { key = "f",                            cb = tree_cb("create") },
  { key = "x",                            cb = tree_cb("remove") },
  { key = "r",                            cb = tree_cb("rename") },
  { key = "R",                            cb = tree_cb("full_rename") },
  { key = "m",                            cb = tree_cb("cut") },
  { key = "c",                            cb = tree_cb("copy") },
  { key = "p",                            cb = tree_cb("paste") },
  { key = "y",                            cb = tree_cb("copy_name") },
  { key = "Y",                            cb = tree_cb("copy_path") },
  { key = "gy",                           cb = tree_cb("copy_absolute_path") },
  { key = "[c",                           cb = tree_cb("prev_git_item") },
  { key = "]c",                           cb = tree_cb("next_git_item") },
  { key = "q",                            cb = tree_cb("close") },
  { key = "g?",                           cb = tree_cb("toggle_help") },
}

