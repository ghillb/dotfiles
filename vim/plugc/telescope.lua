local ok, telescope = pcall(require, 'telescope')
if not ok then
  return
end

local actions = require('telescope.actions')

local config = {
  defaults = {
    layout_config = {
      horizontal = {
        preview_width = 0.6
      },
      center = {
      },
      vertical = {
      }
    },
    mappings = {
      i = {
        ["<c-s>"] = actions.file_split,
        ["<esc>"] = actions.close,
        ["<c-w>"] = actions.send_selected_to_qflist,
        ["<c-q>"] = actions.send_to_qflist,
      },
      n = {
        ["<c-s>"] = actions.file_split,
        ["<c-w>"] = actions.send_selected_to_qflist,
        ["<c-q>"] = actions.send_to_qflist,
      }
    }
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      theme = "dropdown",
      previewer = false,
      mappings = {
        i = {
          ["<c-d>"] = actions.delete_buffer,
        },
        n = {
          ["<c-d>"] = actions.delete_buffer,
        }
      }
    },
    find_files = {
      hidden = true,
      file_ignore_patterns = {
        "^.git/"
      }
    },
    live_grep = {
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
        '--hidden',
        '-g',
        '!.git/'
      },
    }
  },
  extensions = {
    project = {
      base_dirs = {
        {'~/code'},
        {'~/.files'},
      },
      hidden_files = true
    }
  }
}

telescope.setup(config)
telescope.load_extension('project')

