local packer_opts = {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "main",
  requires = {
    "nvim-lua/plenary.nvim",
    "kyazdani42/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },

  config = function()
    vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

    require("neo-tree").setup({
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = false,
      default_component_configs = {
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
          with_expanders = nil,
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "ﰊ",
          default = "*",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
        },
        git_status = {
          symbols = {
            added = "✚",
            deleted = "✖",
            modified = "",
            renamed = "",
            untracked = "?",
            ignored = "∅",
            unstaged = "",
            staged = "",
            conflict = "",
          },
        },
      },
      window = {
        position = "left",
        width = 35,
        mappings = {
          ["<space>"] = "toggle_node",
          ["<2-LeftMouse>"] = "open",
          ["l"] = "open",
          ["<c-s>"] = "open_split",
          ["<c-v>"] = "open_vsplit",
          ["h"] = "close_node",
          ["<bs>"] = "navigate_up",
          ["<cr>"] = "set_root",
          ["."] = "toggle_hidden",
          ["R"] = "refresh",
          ["//"] = "fuzzy_finder",
          ["?"] = "filter_on_submit",
          ["<c-l>"] = "clear_filter",
          ["f"] = "add",
          ["F"] = "add_directory",
          ["x"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["d"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["c"] = "copy",
          ["m"] = "move",
          ["q"] = "close_window",
        },
      },
      nesting_rules = {},
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {
            ".git",
          },
          never_show = {
            ".git",
          },
        },
        follow_current_file = true,
        hijack_netrw_behavior = "disabled",
        use_libuv_file_watcher = true,
      },
      buffers = {
        show_unloaded = true,
        window = {
          mappings = {
            ["bd"] = "buffer_delete",
          },
        },
      },
      git_status = {
        window = {
          position = "float",
          mappings = {
            ["A"] = "git_add_all",
            ["gu"] = "git_unstage_file",
            ["ga"] = "git_add_file",
            ["gr"] = "git_revert_file",
            ["gc"] = "git_commit",
            ["gp"] = "git_push",
            ["gg"] = "git_commit_and_push",
          },
        },
      },
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function(arg)
            vim.wo.signcolumn = "auto"
            vim.wo.fillchars = "eob: "
            DisableTelescopeMappings()
          end,
        },
      },
    })
  end,
}
return packer_opts
