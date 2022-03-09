local ok, nvimtree_config = pcall(require, "nvim-tree.config")
if not ok then
  return
end

vim.g.nvim_tree_auto_ignore_ft = { "alpha", "dashboard", "copy-mode" }
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_git_hl = 0
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_root_folder_modifier = ":~"
vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_icon_padding = " "
vim.g.nvim_tree_show_icons = { git = 1, folders = 0, files = 0, folder_arrows = 1 }
vim.g.nvim_tree_special_files = { ["README"] = 1, ["README.md"] = 1, [".gitlab-ci.yml"] = 1 }
vim.g.nvim_tree_icons = {
  default = "", -- ''
  symlink = "",
  git = {
    unstaged = "!",
    staged = "✓",
    unmerged = "",
    renamed = "➜",
    untracked = "?",
    deleted = "◯",
    ignored = "∅",
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
}

local tree_cb = nvimtree_config.nvim_tree_callback

local mappings_table = {
  { key = { "o", "l" }, cb = tree_cb("edit") },
  { key = "<CR>", cb = ":lua NvimTreeConfig.cd_or_open()<cr>" },
  { key = "<a-esc>", cb = "<c-w>l" },
  { key = "<C-v>", cb = tree_cb("vsplit") },
  { key = "<C-s>", cb = tree_cb("split") },
  { key = "<C-t>", cb = tree_cb("tabnew") },
  { key = "<C-l>", cb = tree_cb("refresh") },
  { key = "K", cb = tree_cb("prev_sibling") },
  { key = "J", cb = tree_cb("next_sibling") },
  { key = "<", cb = tree_cb("first_sibling") },
  { key = ">", cb = tree_cb("last_sibling") },
  { key = "P", cb = tree_cb("parent_node") },
  { key = "h", cb = tree_cb("close_node") },
  { key = "<BS>", cb = tree_cb("dir_up") },
  { key = "<Tab>", cb = tree_cb("preview") },
  { key = "i", cb = tree_cb("toggle_ignored") },
  { key = ".", cb = tree_cb("toggle_dotfiles") },
  { key = "f", cb = tree_cb("create") },
  { key = "x", cb = tree_cb("remove") },
  { key = "r", cb = tree_cb("rename") },
  { key = "R", cb = tree_cb("full_rename") },
  { key = "m", cb = tree_cb("cut") },
  { key = "c", cb = tree_cb("copy") },
  { key = "p", cb = tree_cb("paste") },
  { key = "y", cb = tree_cb("copy_name") },
  { key = "Y", cb = tree_cb("copy_path") },
  { key = "gy", cb = tree_cb("copy_absolute_path") },
  { key = "[c", cb = tree_cb("prev_git_item") },
  { key = "]c", cb = tree_cb("next_git_item") },
  { key = "q", cb = tree_cb("close") },
  { key = "<a-q>", cb = tree_cb("close") },
  { key = "g?", cb = tree_cb("toggle_help") },
  { key = "<c-p>", cb = "<c-w>l" },
  { key = "<c-e>", cb = "<c-w>l" },
  { key = "<c-b>", cb = "<c-w>l" },
  { key = "<c-g>", cb = "<c-w>l" },
  { key = "<c-\\>", cb = "<c-w>l" },
  { key = "<esc><esc>", cb = "<c-w>l" },
}

_G.NvimTreeConfig = {
  disable_netrw = false,
  hijack_netrw = false,
  open_on_setup = false,
  ignore_ft_on_setup = {},
  auto_close = true,
  open_on_tab = true,
  hijack_cursor = true,
  update_cwd = true,
  diagnostics = {
    enable = true,
    icons = {
      error = DiagnosticSigns.Error,
      warning = DiagnosticSigns.Warn,
      hint = DiagnosticSigns.Hint,
      info = DiagnosticSigns.Info,
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  system_open = {
    cmd = nil,
    args = {},
  },
  update_to_buf_dir = {
    enable = false,
  },
  view = {
    width = 30,
    side = "left",
    auto_resize = false,
    mappings = {
      custom_only = true,
      list = mappings_table,
    },
  },
  filters = {
    dotfiles = false,
    custom = { ".git", "node_modules", ".cache" },
  },
  git = {
    ignore = true,
  },
  actions = {
    open_file = {
      quit_on_open = true,
    },
    window_picker = {
      exclude = { filetype = { "packer", "qf" }, buftype = { "terminal" } },
    },
  },
}

local nvimtree = require("nvim-tree")

function _G.NvimTreeConfig.cd_or_open()
  local lib = require("nvim-tree.lib")
  local node = lib.get_node_at_cursor()
  if node then
    if node.entries then
      nvimtree.on_keypress("cd")
    else
      nvimtree.on_keypress("edit")
    end
  end
end

nvimtree.setup(_G.NvimTreeConfig)
