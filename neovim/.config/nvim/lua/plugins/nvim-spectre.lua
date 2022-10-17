local packer_opts = {
  "nvim-pack/nvim-spectre",
  config = function()
    vim.keymap.set(
      { "n", "v" },
      "<leader>?",
      "<cmd>lua require('spectre').open_visual({select_word=true})<cr>:wincmd o<cr>",
      { silent = true }
    )
    vim.keymap.set(
      "n",
      "<leader>/",
      "<cmd>lua require('spectre').open_file_search()<cr>:wincmd o<cr>",
      { silent = true }
    )
    local config = {
      color_devicons = true,
      open_cmd = "vnew",
      live_update = false,
      highlight = {
        ui = "Identifier",
        search = "DiffDelete",
        replace = "DiffAdd",
      },
      mapping = {
        ["toggle_line"] = {
          map = "dd",
          cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
          desc = "toggle current item",
        },
        ["enter_file"] = {
          map = "<cr>",
          cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
          desc = "goto current file",
        },
        ["send_to_qf"] = {
          map = "gq",
          cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
          desc = "send all item to quickfix",
        },
        ["replace_cmd"] = {
          map = "gc",
          cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
          desc = "input replace vim command",
        },
        ["show_option_menu"] = {
          map = "go",
          cmd = "<cmd>lua require('spectre').show_options()<CR>",
          desc = "show option",
        },
        ["run_replace"] = {
          map = "gr",
          cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
          desc = "replace all",
        },
        ["change_view_mode"] = {
          map = "tv",
          cmd = "<cmd>lua require('spectre').change_view()<CR>",
          desc = "change result view mode",
        },
        ["toggle_live_update"] = {
          map = "tu",
          cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
          desc = "update change when vim write file.",
        },
        ["toggle_ignore_case"] = {
          map = "tc",
          cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
          desc = "toggle ignore case",
        },
        ["toggle_ignore_hidden"] = {
          map = "th",
          cmd = "<cmd>lua require('spectre').change_options('ignore-hidden')<CR>",
          desc = "toggle include hidden",
        },
        ["toggle_ignored_files"] = {
          map = "ti",
          cmd = "<cmd>lua require('spectre').change_options('show-ignored')<CR>",
          desc = "toggle include ignored",
        },
      },
      find_engine = {
        ["rg"] = {
          cmd = "rg",
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
          },
          options = {
            ["ignore-case"] = {
              value = "--ignore-case",
              icon = "[C]",
              desc = "toggle case",
            },
            ["ignore-hidden"] = {
              value = "--hidden",
              desc = "toggle hidden",
              icon = "[H]",
            },
            ["show-ignored"] = {
              value = "--no-ignore",
              desc = "toggle ignored",
              icon = "[I]",
            },
          },
        },
      },
      replace_engine = {
        ["sed"] = {
          cmd = "sed",
          args = nil,
        },
        options = {},
      },
      default = {
        find = {
          cmd = "rg",
          options = { "ignore-case", "ignore-hidden", "show-ignored" },
        },
        replace = {
          cmd = "sed",
        },
      },
      replace_vim_cmd = "cdo",
      is_open_target_win = false,
      is_insert_mode = false,
    }
    require("spectre").setup(config)
  end,
}
return packer_opts
