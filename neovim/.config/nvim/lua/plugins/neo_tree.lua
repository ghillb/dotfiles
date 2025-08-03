return function()
  vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

  require("neo-tree").setup({
    close_if_last_window = true,
    window = {
      width = 32,
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
        ["<C-s>"] = {
          function(state)
            local node = state.tree:get_node()
            if node and node.type == "file" then
              local file_path = node:get_id()
              local cmd = string.format("git add -f %s", vim.fn.shellescape(file_path))
              local result = vim.fn.system(cmd)
              
              if vim.v.shell_error == 0 then
                vim.notify("Staged: " .. node.name, vim.log.levels.INFO)
                require("neo-tree.sources.manager").refresh("filesystem")
              else
                vim.notify("Failed to stage: " .. result, vim.log.levels.ERROR)
              end
            else
              vim.notify("Please select a file to stage", vim.log.levels.WARN)
            end
          end,
          desc = "Force stage file",
        },
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