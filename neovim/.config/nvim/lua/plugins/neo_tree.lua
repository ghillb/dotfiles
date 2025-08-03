return function()
  vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

  require("neo-tree").setup({
    close_if_last_window = true,
    window = {
      width = 32,
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
      },
    },
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      hijack_netrw_behavior = "open_current",
    },
    event_handlers = {
      {
        event = "file_opened",
        handler = function(arg)
          vim.cmd("Neotree close")
        end,
      },
    },
  })
end